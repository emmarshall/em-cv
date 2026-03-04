# CV Data for Emma W. Marshall
# Run this script to update cv_data.rda after making changes

library(tibble)

#-------------------------------------------------------------------------------
# Education
#-------------------------------------------------------------------------------
education <- tribble(
  ~degree, ~institution, ~institution_url, ~location, ~date, ~thesis_type, ~thesis_title,
  "Ph.D. in Social and Cognitive Psychology", "University of Nebraska-Lincoln", "", "Lincoln, NE", "August 2026 (Expected)", "Dissertation", "What to Suspect When They're Expecting: Abortion Ambiguity, Hindsight Bias, and Probable Cause Determinations in Pregnancy Loss Investigations After Dobbs",
  "Juris Doctorate", "University of Nebraska-Lincoln", "", "Lincoln, NE", "May 2022", "Concentration", "Constitutional Law",
  "M.A. in Social and Cognitive Psychology", "University of Nebraska-Lincoln", "", "Lincoln, NE", "May 2022", "Thesis", "Warrantless Searches, Hindsight Bias and Probable Cause",
  "B.A. in Psychology", "Pomona College, With Distinction", "https://www.pomona.edu", "Claremont, CA", "May 2014", "Senior Thesis", "I got 99 Friends but the Police ain't One: Facebook, Privacy, and the Fourth Amendment"
)

#-------------------------------------------------------------------------------
# Professional Experience
#-------------------------------------------------------------------------------
prof_exp <- tribble(
  ~title, ~organization, ~organization_url, ~location, ~date, ~description,
  "Editorial Assistant, Court Review", "American Judges Association", "https://www.americanjudgesassociation.org/court-review", "Lincoln, NE", "August 2022 - Present", "Manage manuscript workflow, perform copyediting, coordinate with authors and reviewers, and assist with publication layout for the quarterly journal serving the American judiciary",
  "Graduate Research Assistant", "The Center for Children, Families, and the Law", "https://ccfl.unl.edu", "Lincoln, NE", "May 2019 - May 2023", "Developed and evaluated training curricula for DCFS Child Protection and Safety New Worker Training; created educational materials and assessments for child welfare professionals",
  "Graduate Research Assistant", "Law and Policy Lab, University of Nebraska-Lincoln", "https://lawpolicylab.unl.edu/", "Lincoln, NE", "August 2016 - Present", "Design and conduct experimental research on Fourth Amendment issues, consent searches, and privacy expectations; manage data collection and analysis; Principal Investigator: Eve M. Brank, JD/PhD",
  "Lab Manager", "Legal Decision-Making Research Lab, Scripps College", "https://www.scrippscollege.edu", "Claremont, CA", "May 2014 - August 2016", "Supervised undergraduate research assistants, managed IRB protocols and lab operations, coordinated multi-site data collection, and maintained research databases; Principal Investigator: Jennifer Groscup, J.D./Ph.D.",
  "Undergraduate Research Assistant", "Legal Decision-Making Research Lab, Scripps College", "", "Claremont, CA", "August 2012 - May 2014", "Conducted participant recruitment and data collection, performed behavioral coding, completed systematic literature reviews, and assisted with manuscript preparation; Principal Investigator: Jennifer Groscup, JD/PhD"
)

#-------------------------------------------------------------------------------
# Teaching Experience
#-------------------------------------------------------------------------------
teaching <- tribble(
  ~title, ~course_name, ~course_num, ~institution, ~institution_url, ~location, ~date, ~size, ~modality, ~website, ~syllabus,
  "Teaching Assistant", "Research Methods and Data Analysis", "PSYC 350", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Fall 2023 - Spring 2026", "20-30 students", "Lab", "", "",
  "Instructor", "Law and Psychology", "PSYC 401", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Summer 2025", "25-30 students", "Online", "", "",
  "Instructor", "Introduction to Psychology", "PSYC 181", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Summer 2024", "25-30 students", "Online", "https://emmarshall.github.io/PSYC181-UNL/", "",
  "Instructor", "Psychology of Social Behavior", "PSYC 288", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Summer 2019", "15-20 students", "Lecture", "", "",
  "Co-Instructor", "Law and Psychology", "PSYC 401", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Fall 2018", "25-30 students", "Lecture", "", "",
  "Instructor", "Law and Psychology", "PSYC 401", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Summer 2018", "15-20 students", "Lecture", "", "",
  "Teaching Assistant", "Law and Psychology", "PSYC 401", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Spring 2018", "25-30 students", "Lecture", "", "",
  "Teaching Assistant", "Senior Thesis in Psychology", "PSYC 190", "Scripps College", "", "Claremont, CA", "Fall 2015 - Spring 2016", "10-15 students", "Seminar", "", ""
)

#-------------------------------------------------------------------------------
# Workshops and Guest Lectures
#-------------------------------------------------------------------------------
workshops <- tribble(
  ~title, ~type, ~venue, ~venue_url, ~location, ~date, ~website, ~slides,
  "A.I. and Legal Decision Making", "Guest Lecturer", "Law and Psychology, UNL", "", "Lincoln, NE", "Fall 2024, Spring 2025", "", "https://emmarshall.github.io/slides/talks/ai-guest-lecture-2025/#/title-slide",
  "The Psychology and Law of Section 230", "Guest Lecturer", "Law and Psychology, UNL", "", "Lincoln, NE", "Spring 2025", "https://emmarshall.github.io/section230-psych/", "",
  "Introduction to Jamovi", "Workshop", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Fall 2024, Fall 2025", "https://emmarshall.github.io/jamovi-workshop-lab/", "",
  "Using Zotero for Psychology and Law Research", "Workshop", "University of Nebraska-Lincoln", "", "Lincoln, NE", "Fall 2024, Fall 2025", "https://emmarshall.github.io/zotero-lab/", "",
  "Judicial Decision-Making", "Guest Lecturer", "Law and Psychology, UNL", "", "Lincoln, NE", "Spring 2023", "", "https://emmarshall.github.io/slides/talks/judges-guest-lecture/#/title-slide",
  "Introduction to Expert Testimony: A Legal Workshop", "Workshop", "AP-LS Annual Meeting", "", "Denver, CO", "2022", "http://www.apls-students.org/uploads/4/6/5/6/46564967/apls_2022_legal_primer_-_expert_witnesses.pdf", "http://www.apls-students.org/uploads/4/6/5/6/46564967/apls_2022_-_legal_seminar.pdf",
  "What is a Contract and Why Do I Care?: Exploring the Relationship between Psychology and Contract Law", "Workshop", "AP-LS Annual Meeting", "", "New Orleans, LA", "2020", "", "http://www.apls-students.org/uploads/4/6/5/6/46564967/contracts_workshop__apls_2020_.pdf",
  "Psychology and the Law in the American Legal System", "Guest Lecturer", "Santo Tomas University", "", "Bogota, Colombia", "Fall 2022", "", "https://emmarshall.github.io/slides/talks/psychlaw/#/title-slide",
  "What is Free Speech and Will I Know It When I See It?", "Workshop", "AP-LS Annual Meeting", "", "Portland, OR", "2019", "", "http://www.apls-students.org/uploads/4/6/5/6/46564967/first_amendment_apls1.pdf",
  "Privacy and the Fourth Amendment", "Workshop", "AP-LS Annual Meeting", "", "Memphis, TN", "2018", "http://www.apls-students.org/uploads/4/6/5/6/46564967/fourth_amendment_primer_.pdf", "http://www.apls-students.org/uploads/4/6/5/6/46564967/fourth_amendment_workshop.pdf",
  "Psychology of Jury Decision-Making", "Guest Lecturer", "Advanced Social Psychology, UNL", "", "Lincoln, NE", "Summer 2018", "", ""
)

#-------------------------------------------------------------------------------
# Professional Service
#-------------------------------------------------------------------------------
service <- tribble(
  ~title, ~organization, ~organization_url, ~location, ~date,
  "Student Member, Early Career Professionals Committee", "American Psychology-Law Society", "https://www.apadivisions.org/division-41", "", "2023 - 2025",
  "Past-Chair, Student Committee", "American Psychology-Law Society", "https://www.apadivisions.org/division-41", "", "2021 - 2022",
  "Chair, Online Poster Session", "American Psychology-Law Society", "", "", "2021",
  "Chair, Student Committee", "American Psychology-Law Society", "https://www.apadivisions.org/division-41", "", "2020 - 2021",
  "Chair-Elect, Student Committee", "American Psychology-Law Society", "https://www.apadivisions.org/division-41", "", "2019 - 2020",
  "Student Reviewer", "Law and Human Behavior", "https://www.apa.org/pubs/journals/lhb", "", "2022 - 2025",
  "Student Web Editor", "American Psychology-Law Society", "https://www.apadivisions.org/division-41", "", "2019 - Present",
  "Law-Psychology Representative", "UNL Graduate Student Assembly", "", "Lincoln, NE", "2018 - 2019",
  "Student Reviewer, Annual Meeting", "American Psychology-Law Society", "", "", "2018 - 2026",
  "Law Liaison, Student Committee", "American Psychology-Law Society", "https://www.apadivisions.org/division-41", "", "2017 - 2019",
  "Board Member", "Pomona College Alumni Association", "https://www.pomona.edu/alumni", "Claremont, CA", "2014 - 2017",
  "Senior Class President", "Associated Students of Pomona College", "", "Claremont, CA", "2013 - 2014",
  "President and Co-Founder", "Title IX Student Coalition, Pomona College", "", "Claremont, CA", "2013 - 2014"
)

#-------------------------------------------------------------------------------
# Professional Memberships
#-------------------------------------------------------------------------------
memberships <- tribble(
  ~title, ~title_url, ~date, ~description,
  "Law & Society Association", "https://www.lawandsociety.org/", "2024 - Present", "Student Member",
  "Society for the Teaching of Psychology", "https://teachpsych.org/", "2024 - Present", "Student Member",
  "American Psychology-Law Society", "https://www.ap-ls.org", "2012 - Present", "Student Member",
  "American Psychological Association", "https://www.apa.org", "2014 - Present", "Student Member"
)

#-------------------------------------------------------------------------------
# Professional Honors and Awards
#-------------------------------------------------------------------------------
awards <- tribble(
  ~title, ~organization, ~organization_url, ~date, ~amount,
  "CALI Excellence for the Future Award, Family Law", "University of Nebraska College of Law", "", "2019", "",
  "CALI Excellence for the Future Award, Juvenile Law", "University of Nebraska College of Law", "", "2019", "",
  "CALI Excellence for the Future Award, Legal Profession", "University of Nebraska College of Law", "", "2019", "",
  "Conference Student Travel Award", "AP-LS, APA Division 41", "", "2015", "",
  "Distinction in the Senior Thesis Exercise", "Pomona College Psychology Department", "", "2014", "",
  "Senior Service Award", "Pomona College", "", "2014", "",
  "Student Travel Grant", "Pomona College Psychology Department", "", "2014", "",
  "Pomona College Scholar", "Pomona College", "", "2012 - 2014", ""
)

#-------------------------------------------------------------------------------
# Save all data to a single .rda file
#-------------------------------------------------------------------------------
cv_data <- list(
  education = education,
  prof_exp = prof_exp,
  teaching = teaching,
  workshops = workshops,
  service = service,
  memberships = memberships,
  awards = awards
)

save(cv_data, file = "cv_data.rda")

message("CV data saved to cv_data.rda")
