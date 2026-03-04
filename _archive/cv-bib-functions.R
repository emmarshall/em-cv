# =============================================================================
# CV Bibliography Functions
# Read BibTeX and format for Typst CV in APA style
# =============================================================================

library(bib2df)
library(dplyr)
library(stringr)
library(glue)
library(purrr)
library(tidyr)

# -----------------------------------------------------------------------------
# Core BibTeX Reading Function
# -----------------------------------------------------------------------------

#' Read and parse a BibTeX file for CV use
#'
#' @param bib_path Path to the .bib file
#' @param highlight_author Author name pattern to bold (regex)
#' @return A tibble with parsed bibliography entries
read_cv_bib <- function(bib_path,
                        highlight_author = "Marshall, E(mma)?( W\\.)?") {

  bib <- bib2df::bib2df(bib_path) |>
    janitor::clean_names() |>
    mutate(
      # Parse keywords into a list column
      keyword_list = str_split(keywords, ",\\s*"),
      # Extract mentees from usermeta if present
      mentees = str_extract(usermeta, "(?<=mentees=)[^;]+") |>
        str_split(";") |>
        map(\(x) if (all(is.na(x))) character(0) else x),
      # Extract additional URLs from usermeta
      slides_url = str_extract(usermeta, "(?<=slides=)[^;]+"),
      # Clean up note field
      note = replace_na(note, "")
    )

  bib
}

# -----------------------------------------------------------------------------
# Author Formatting Functions
# -----------------------------------------------------------------------------

#' Format author list from BibTeX format to APA style
#'
#' @param authors Character vector of author names in "Last, First" format
#' @param highlight_pattern Regex pattern to bold
#' @param mentees Character vector of mentee names to mark with †
#' @return Formatted author string
format_authors_apa <- function(authors,

                               highlight_pattern = "Marshall, E(mma)?( W\\.)?",
                               mentees = character(0)) {

  if (length(authors) == 0 || all(is.na(authors))) return("")

  # Handle if authors is a list column (single element)
  if (is.list(authors)) {
    authors <- unlist(authors)
  }

  # Convert full names to initials: "Emma W. Marshall" -> "Marshall, E. W."
  format_single_author <- function(name) {
    name <- str_trim(name)

    # Check if already in "Last, First" format

    if (str_detect(name, ",")) {
      parts <- str_split(name, ",\\s*")[[1]]
      last <- parts[1]
      first_parts <- str_split(str_trim(parts[2]), "\\s+")[[1]]
      initials <- map_chr(first_parts, \(x) paste0(str_sub(x, 1, 1), "."))
      return(paste0(last, ", ", paste(initials, collapse = " ")))
    }

    # "First Middle Last" format
    parts <- str_split(name, "\\s+")[[1]]
    if (length(parts) == 1) return(name)

    last <- parts[length(parts)]
    first_parts <- parts[-length(parts)]
    initials <- map_chr(first_parts, \(x) {
      # Keep existing initials (e.g., "E." stays "E.")
      if (str_detect(x, "\\.$")) return(x)
      paste0(str_sub(x, 1, 1), ".")
    })

    paste0(last, ", ", paste(initials, collapse = " "))
  }

  # Format each author
  formatted <- map_chr(authors, format_single_author)

  # Mark mentees with dagger
  if (length(mentees) > 0 && !all(is.na(mentees))) {
    mentees <- unlist(mentees)
    for (mentee in mentees) {
      if (!is.na(mentee) && mentee != "") {
        # Match the last name
        last_name <- str_extract(mentee, "^[^,]+")
        pattern <- paste0("(^|, |& )(", last_name, ",)")
        formatted <- str_replace(
          paste(formatted, collapse = "---SEP---"),
          pattern,
          "\\1†\\2"
        ) |>
          str_split("---SEP---") |>
          unlist()
      }
    }
  }

  # Highlight the target author
  formatted <- map_chr(formatted, \(a) {
    if (str_detect(a, highlight_pattern)) {
      paste0("*", a, "*")
    } else {
      a
    }
  })

  # Join with proper APA separators
  n <- length(formatted)
  if (n == 1) {
    formatted[1]
  } else if (n == 2) {
    paste(formatted, collapse = " & ")
  } else {
    paste0(
      paste(formatted[-n], collapse = ", "),
      ", & ",
      formatted[n]
    )
  }
}

# -----------------------------------------------------------------------------
# Publication Type Formatters
# -----------------------------------------------------------------------------

#' Format a journal article in APA style
format_article <- function(entry) {
  authors <- format_authors_apa(entry$author[[1]])
  year <- entry$year
  title <- entry$title

  # Build source line
  source_parts <- c()

  if (!is.na(entry$journal) && entry$journal != "") {
    journal_part <- paste0("_", entry$journal, "_")

    if (!is.na(entry$volume) && entry$volume != "") {
      journal_part <- paste0(journal_part, ", _", entry$volume, "_")

      if (!is.na(entry$number) && entry$number != "") {
        journal_part <- paste0(journal_part, "(", entry$number, ")")
      }
    }

    if (!is.na(entry$pages) && entry$pages != "") {
      journal_part <- paste0(journal_part, ", ", entry$pages)
    }

    source_parts <- c(source_parts, journal_part)
  } else if (!is.na(entry$publisher) && entry$publisher != "") {
    source_parts <- c(source_parts, paste0("_", entry$publisher, "_"))
  }

  source <- paste(source_parts, collapse = "")

  # Create linked title
  if (!is.na(entry$doi) && entry$doi != "") {
    title_linked <- glue('#link("https://doi.org/{entry$doi}")[{title}]')
  } else if (!is.na(entry$url) && entry$url != "") {
    title_linked <- glue('#link("{entry$url}")[{title}]')
  } else {
    title_linked <- title
  }

  tibble(
    title = as.character(title_linked),
    date = as.character(year),
    location = "",
    description = glue("{authors} #linebreak() {source}")
  )
}

#' Format a manuscript (unpublished) in APA style
format_manuscript <- function(entry) {
  authors <- format_authors_apa(entry$author[[1]])
  title <- entry$title

  # Parse status from note
  status <- case_when(
    str_detect(entry$note, "Under review") ~ "Under review",
    str_detect(entry$note, "In preparation") ~ "In preparation",
    TRUE ~ "In preparation"
  )

  # Extract journal if under review
  journal <- str_extract(entry$note, "(?<=at ).*$") |>
    replace_na("")

  description <- if (journal != "") {
    glue("{authors} #linebreak() _{journal}_")
  } else {
    authors
  }

  tibble(
    title = title,
    date = status,
    location = "",
    description = as.character(description)
  )
}

#' Format a conference presentation in APA style
format_presentation <- function(entry) {
  authors <- format_authors_apa(
    entry$author[[1]],
    mentees = entry$mentees[[1]]
  )
  title <- entry$title
  conference <- entry$booktitle
  location <- entry$address
  year <- entry$year

  # Extract presentation type from note
  pres_type <- case_when(
    str_detect(entry$note, "Paper") ~ "Paper",
    str_detect(entry$note, "Poster") ~ "Poster",
    str_detect(entry$note, "Symposium") ~ "Symposium",
    TRUE ~ "Presentation"
  )

  # Check for mentees
  has_mentees <- length(entry$mentees[[1]]) > 0 &&
    !all(is.na(entry$mentees[[1]]))

  description <- if (has_mentees) {
    glue("{conference} #linebreak() {authors} ({pres_type}) #linebreak() _†Undergraduate mentee_")
  } else {
    glue("{conference} #linebreak() {authors} ({pres_type})")
  }

  tibble(
    title = title,
    date = as.character(year),
    location = location,
    description = as.character(description)
  )
}

#' Format a workshop or guest lecture
format_workshop <- function(entry) {
  # Handle author - may be single author
  if (length(entry$author[[1]]) > 1 ||
      (length(entry$author[[1]]) == 1 && !is.na(entry$author[[1]][1]))) {
    authors <- format_authors_apa(
      entry$author[[1]],
      mentees = entry$mentees[[1]]
    )
  } else {
    authors <- ""
  }

  title <- entry$title
  venue <- entry$howpublished
  location <- entry$address
  date_info <- entry$note

  # Build icons for URLs
  icons <- character(0)

  if (!is.na(entry$url) && entry$url != "") {
    # Determine icon type based on usermeta or URL
    icon_type <- case_when(
      str_detect(entry$usermeta, "type=slides") ~ "file-powerpoint",
      str_detect(entry$url, "slides") ~ "file-powerpoint",
      TRUE ~ "globe"
    )
    icons <- c(icons, glue('#link("{entry$url}")[#fa-icon("{icon_type}")]'))
  }

  if (!is.na(entry$slides_url) && entry$slides_url != "") {
    icons <- c(icons, glue('#link("{entry$slides_url}")[#fa-icon("file-powerpoint")]'))
  }

  title_with_icons <- if (length(icons) > 0) {
    paste(title, paste(icons, collapse = " "))
  } else {
    title
  }

  # Check for mentees
  has_mentees <- length(entry$mentees[[1]]) > 0 &&
    !all(is.na(entry$mentees[[1]]))

  # Build description
  desc_parts <- c(venue)
  if (authors != "") {
    desc_parts <- c(desc_parts, authors)
  }
  if (has_mentees) {
    desc_parts <- c(desc_parts, "_†Undergraduate mentee_")
  }

  description <- paste(desc_parts, collapse = " #linebreak() ")

  tibble(
    title = title_with_icons,
    date = as.character(date_info),
    location = location,
    description = description
  )
}

# -----------------------------------------------------------------------------
# Main Processing Functions
# -----------------------------------------------------------------------------

#' Get publications from bibliography
#'
#' @param bib Parsed bibliography tibble from read_cv_bib()
#' @return Tibble formatted for resume_entry()
get_publications <- function(bib) {
  bib |>
    filter(
      category == "ARTICLE",
      map_lgl(keyword_list, \(k) "publication" %in% k)
    ) |>
    arrange(desc(year)) |>
    rowwise() |>
    group_map(\(row, ...) format_article(row)) |>
    bind_rows()
}

#' Get manuscripts from bibliography
#'
#' @param bib Parsed bibliography tibble
#' @param status Filter by status: "all", "under-review", or "in-preparation"
#' @return Tibble formatted for resume_entry()
get_manuscripts <- function(bib, status = "all") {
  filtered <- bib |>
    filter(
      category == "UNPUBLISHED",
      map_lgl(keyword_list, \(k) "manuscript" %in% k)
    )

  if (status == "under-review") {
    filtered <- filtered |>
      filter(map_lgl(keyword_list, \(k) "under-review" %in% k))
  } else if (status == "in-preparation") {
    filtered <- filtered |>
      filter(map_lgl(keyword_list, \(k) "in-preparation" %in% k))
  }

  # Sort: under review first, then in preparation
  filtered <- filtered |>
    mutate(
      sort_order = case_when(
        map_lgl(keyword_list, \(k) "under-review" %in% k) ~ 1,
        TRUE ~ 2
      )
    ) |>
    arrange(sort_order, desc(year))

  filtered |>
    rowwise() |>
    group_map(\(row, ...) format_manuscript(row)) |>
    bind_rows()
}

#' Get presentations from bibliography
#'
#' @param bib Parsed bibliography tibble
#' @param type Filter by type: "all", "paper", "poster", or "symposium"
#' @return Tibble formatted for resume_entry()
get_presentations <- function(bib, type = "all") {
  filtered <- bib |>
    filter(
      category == "INPROCEEDINGS",
      map_lgl(keyword_list, \(k) "presentation" %in% k)
    )

  if (type != "all") {
    filtered <- filtered |>
      filter(map_lgl(keyword_list, \(k) type %in% k))
  }

  filtered |>
    arrange(desc(year)) |>
    rowwise() |>
    group_map(\(row, ...) format_presentation(row)) |>
    bind_rows()
}

#' Get workshops and guest lectures from bibliography
#'
#' @param bib Parsed bibliography tibble
#' @return Tibble formatted for resume_entry()
get_workshops <- function(bib) {
  bib |>
    filter(
      category == "MISC",
      map_lgl(keyword_list, \(k) "workshop" %in% k)
    ) |>
    arrange(desc(year)) |>
    rowwise() |>
    group_map(\(row, ...) format_workshop(row)) |>
    bind_rows()
}
