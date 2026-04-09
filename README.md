# 🎬 Netflix Dataset Analysis - Exploratory Data Analysis (EDA)

> A comprehensive statistical analysis of Netflix's content library using Python and SQL to uncover business intelligence patterns and strategic insights.

![Python](https://img.shields.io/badge/Python-3.9+-blue?style=flat-square&logo=python)
![SQL](https://img.shields.io/badge/SQL-Advanced-green?style=flat-square&logo=database)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-yellow?style=flat-square)

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Dataset Information](#-dataset-information)
- [Data Cleaning](#-data-cleaning)
- [Key Metrics](#-key-metrics)
- [Analysis & Queries](#-analysis--queries)
- [Key Insights](#-key-insights)
- [Technologies Used](#-technologies-used)
- [File Structure](#-file-structure)
- [How to Run](#-how-to-run)
- [Results & Deliverables](#-results--deliverables)
- [Author](#-author)

---

## 🎯 Project Overview

This project performs an **Exploratory Data Analysis (EDA)** on Netflix's content library containing **8,804 titles**. Through Python-based data analysis and advanced SQL queries, we uncover:

✅ Content distribution patterns  
✅ Geographic market trends  
✅ Temporal growth patterns  
✅ Rating and genre distribution  
✅ Strategic content acquisition insights  
✅ Creator ecosystem analysis  

**Objective:** Understand Netflix's content strategy, identify market patterns, and provide actionable business intelligence.

---

## 📊 Dataset Information

### Dataset Size
- **Total Records:** 8,804 titles (after cleaning)
- **Original Records:** 8,807 titles
- **Time Period:** 1925 - 2021 (97 years)
- **Geographic Coverage:** 123 countries

### Column Descriptions

| Column | Description | Missing Values |
|--------|-------------|-----------------|
| `show_id` | Unique identifier for each title | 0 |
| `type` | Movie or TV Show | 0 |
| `title` | Content name | 0 |
| `director` | Director(s) | 2,634 (29.9%) |
| `cast` | Cast members | 825 (9.4%) |
| `country` | Production country | 831 (9.4%) |
| `date_added` | Date added to Netflix | 10 (0.1%) |
| `release_year` | Original release year | 0 |
| `rating` | Content rating (PG, TV-MA, etc.) | 4 (0.05%) |
| `duration` | Length (minutes) or Seasons | 3 (0.03%) |
| `listed_in` | Genres/categories | 0 |
| `description` | Plot summary | 0 |

---

## 🧹 Data Cleaning

### Cleaning Process

```python
# Step 1: Load dataset
df = pd.read_csv('netflix_titles.csv')
print(f"Initial shape: {df.shape}")  # (8807, 12)

# Step 2: Check missing values
print(df.isnull().sum())

# Step 3: Remove rows with missing duration (critical column)
df.dropna(subset=["duration"], inplace=True)

# Step 4: Reset index
df.reset_index(drop=True, inplace=True)

# Step 5: Verify cleaning
print(f"Final shape: {df.shape}")  # (8804, 12)
print(df.isnull().sum())
```

### Cleaning Results

| Action | Count | Result |
|--------|-------|--------|
| Rows removed (null duration) | 3 | ✅ Removed |
| Final records | 8,804 | ✅ Ready for analysis |
| Data integrity | 99.96% | ✅ High quality |

---

## 📈 Key Metrics

| Metric | Value | Insight |
|--------|-------|---------|
| **Total Titles** | 8,804 | Large, diverse catalog |
| **Movies** | 6,131 (69.62%) | Movie-heavy platform |
| **TV Shows** | 2,676 (30.38%) | Strong TV presence |
| **Countries** | 123 | Global reach |
| **Top Country** | USA (2,818 titles) | 32% of catalog |
| **2nd Country** | India (972 titles) | 11% of catalog |
| **Content Added (Peak)** | 2,016 titles (2019) | Aggressive expansion year |
| **Mature Content** | 75%+ (TV-14+) | Adult audience focus |
| **Drama Genre** | 27.6% | Drama-centric library |

---

## 🔍 Analysis & Queries

### Query 1️⃣ : Content Distribution by Type

**SQL Query:**
```sql
SELECT type,
       COUNT(*) AS Total_titles,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS Percentage
FROM netflix_titles
GROUP BY type
ORDER BY Total_titles DESC;
```

**Results:**
| Type | Total_titles | Percentage |
|------|--------------|-----------|
| Movie | 6,131 | 69.62% |
| TV Show | 2,676 | 30.38% |

**Key Insight:** Netflix catalog is heavily skewed towards movies (2.3x more movies than TV shows), reflecting the platform's strategy to appeal to audiences seeking diverse on-demand content.

---

### Query 2️⃣ : Top 10 Countries by Content Volume

**SQL Query:**
```sql
SELECT TOP (10) country,
       COUNT(title) AS No_of_Titles
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY No_of_Titles DESC;
```

**Results:**
| Rank | Country | Titles |
|------|---------|--------|
| 1 | United States | 2,818 |
| 2 | India | 972 |
| 3 | United Kingdom | 419 |
| 4 | Japan | 245 |
| 5 | South Korea | 199 |
| 6 | Canada | 181 |
| 7 | Spain | 145 |
| 8 | France | 124 |
| 9 | Mexico | 110 |
| 10 | Egypt | 106 |

**Key Insights:**
- 🇺🇸 USA dominates with 32% of catalog
- 🇮🇳 India rapidly expanding (11%)
- 🌍 Top 5 countries = 62% of total content
- 📍 Strategic focus: English-speaking & Asian markets

---

### Query 3️⃣ : Content Added Per Year (Temporal Trends)

**SQL Query:**
```sql
SELECT YEAR(date_added) AS year_added,
       COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY year_added;
```

**Results:**
| Year | Titles Added | Phase |
|------|--------------|-------|
| 2008-2016 | 1-429/year | Slow growth |
| 2017 | 1,188 | Acceleration begins |
| 2018 | 1,649 | Rapid growth |
| 2019 | 2,016 | **Peak year** |
| 2020 | 1,879 | Maintained high |
| 2021 | 1,498 | Slight decline |

**Key Findings:**
- 📊 2017-2020: Aggressive expansion phase (+6,832 titles)
- 📈 2019 peaked as investment year
- 🎯 Response to increased competition from Disney+, Prime Video
- 💡 Strategic shift: From maintenance to aggressive acquisition

---

### Query 4️⃣ : Rating Distribution by Content Type

**SQL Query:**
```sql
SELECT type AS content_type,
       rating,
       COUNT(*) AS count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, count DESC;
```

**Movies - Top Ratings:**
| Rating | Count | Percentage |
|--------|-------|-----------|
| TV-MA | 2,062 | 33.6% |
| TV-14 | 1,427 | 23.3% |
| R | 797 | 13.0% |
| PG-13 | 490 | 8.0% |
| PG | 287 | 4.7% |

**TV Shows - Top Ratings:**
| Rating | Count | Percentage |
|--------|-------|-----------|
| TV-MA | 1,145 | 42.8% |
| TV-14 | 733 | 27.4% |
| TV-PG | 323 | 12.1% |
| TV-Y7 | 195 | 7.3% |
| TV-Y | 176 | 6.6% |

**Key Insights:**
- 🔞 75%+ of content rated TV-14 or higher
- 📺 TV shows have higher maturity (42.8% TV-MA)
- 👨‍👩‍👧‍👦 Family/children content limited (~13%)
- 🎯 Netflix targets primarily adult/mature audiences

---

### Query 5️⃣ : Average Movie Duration by Rating

**SQL Query:**
```sql
SELECT rating,
       ROUND(AVG(CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT)), 1) AS avg_duration_min
FROM netflix_titles
WHERE type = 'Movie' AND duration LIKE '%min%'
GROUP BY rating
ORDER BY avg_duration_min DESC;
```

**Results:**
| Rating | Avg Duration (min) | Pattern |
|--------|-------------------|---------|
| NC-17 | 125 | Complex narratives |
| TV-14 | 110 | Standard length |
| PG-13 | 108 | Family-friendly |
| UR/R | 106 | General content |
| PG | 98 | Accessible |
| TV-MA | 95 | Shorter, focused |
| NR | 94 | Miscellaneous |

**Key Insights:**
- ⏱️ Inverse correlation: Restrictive ratings → longer movies
- 📊 NC-17 (125 min) indicate complex, mature narratives
- 👶 Family content (PG) shorter (98 min) for accessibility
- 🎭 Pattern reveals: Rating reflects content complexity

---

### Query 6️⃣ : Gap Between Release & Addition Date

**SQL Query:**
```sql
SELECT type,
       ROUND(AVG(YEAR(date_added) - release_year), 1) as avg_year_to_add,
       MIN(YEAR(date_added) - release_year) As min_gap,
       MAX(YEAR(date_added) - release_year) As max_gap
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY type;
```

**Results:**
| Type | Avg Gap | Min Gap | Max Gap | Strategy |
|------|---------|---------|---------|----------|
| TV Show | 2 years | -3 years | 93 years | Fresh acquisitions |
| Movie | 5 years | -1 year | 75 years | Backlog building |

**Key Insights:**
- 📺 TV Shows: ~2 years (Netflix acquires shows soon after release)
- 🎬 Movies: ~5 years (acquires older films for catalog)
- 🎯 Strategy: Fresh TV content vs. catalog-filling older films
- 💡 Different acquisition approaches for different content types

---

### Query 7️⃣ : Top Genres by Content Volume

**SQL Query:**
```sql
SELECT TOP(10)
       TRIM(value) AS genre,
       COUNT(*) AS genre_count
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE TRIM(value) <> ''
GROUP BY TRIM(value)
ORDER BY genre_count DESC;
```

**Results:**
| Rank | Genre | Count | % |
|------|-------|-------|---|
| 1 | International Movies | 2,752 | 31.2% |
| 2 | Dramas | 2,427 | 27.6% |
| 3 | Comedies | 1,016 | 11.5% |
| 4 | International TV Shows | 1,351 | 15.3% |
| 5 | Documentaries | 869 | 9.9% |
| 6 | Action & Adventure | 853 | 9.7% |
| 7 | TV Dramas | 763 | 8.7% |
| 8 | Independent Movies | 756 | 8.6% |
| 9 | Children & Family Movies | 641 | 7.3% |
| 10 | Romantic Movies | 616 | 7.0% |

**Key Insights:**
- 🌍 Global/International content dominates (46.5%)
- 🎭 Drama most popular (27.6%)
- 😂 Comedy significant (11.5%)
- 📽️ Netflix positions as global, dramatic content hub

---

### Query 8️⃣ : Most Prolific Directors

**SQL Query:**
```sql
SELECT TOP(10) director,
       COUNT(*) AS title_count,
       STRING_AGG(type, ', ') WITHIN GROUP (ORDER BY type) AS content_type
FROM (SELECT DISTINCT director, type
      FROM netflix_titles
      WHERE director <> 'Unknown')
sub
GROUP BY director
ORDER BY title_count DESC;
```

**Results:**
| Director | Titles | Content Type |
|----------|--------|--------------|
| Alessandro Angulo | 2 | Movie, TV Show |
| BB Sasore | 2 | Movie, TV Show |
| Billy Corben | 2 | Movie, TV Show |
| Brad Anderson | 2 | Movie, TV Show |
| Bunmi Ajakaiye | 2 | Movie, TV Show |
| Cosima Spender | 2 | Movie, TV Show |
| Dan Forrer | 2 | Movie, TV Show |
| Daniel Kontur | 2 | Movie, TV Show |
| David Ayer | 2 | Movie, TV Show |
| Eli Roth | 2 | Movie, TV Show |

**Key Insights:**
- 👥 No single director dominates (fragmented ecosystem)
- 🎬 Most prolific directors work across movie & TV
- 🎯 Netflix avoids over-reliance on individual talent
- 💼 Risk mitigation through diverse creator portfolio

---

## 💡 Key Insights

### 1. Market Strategy
- 🇺🇸 **USA Focus:** Dominates with 32% of catalog (2,818 titles)
- 🌏 **Asian Expansion:** India (11%), Japan, South Korea growing
- 🌍 **Global Reach:** 46.5% of content from non-USA origins

### 2. Content Philosophy
- 📊 **Volume Strategy:** 8,804 titles across diverse genres
- 🎭 **Drama-Heavy:** 27.6% of catalog are dramas
- 🌐 **International Focus:** International movies/shows = 46.5%

### 3. Acquisition Timeline
- 📈 **2017-2020:** Aggressive expansion (6,832 new titles = 68%)
- 📊 **Peak Year:** 2019 (2,016 titles) - response to competition
- 🎯 **Inflection Point:** 2017 marks shift to growth strategy

### 4. Audience Targeting
- 🔞 **Mature Focus:** 75%+ rated TV-14 or higher
- 👨‍👩‍👧‍👦 **Limited Family:** ~13% children/family content
- 📺 **TV vs Movies:** TV shows have higher maturity (42.8% TV-MA)

### 5. Creator Ecosystem
- 👥 **Fragmented Base:** No director with >2 titles
- 📝 **Diverse Portfolio:** Mix of established and emerging creators
- 💼 **Risk Management:** Avoids over-reliance on superstar talent

---

## 🛠 Technologies Used

### Languages & Libraries
- **Python 3.13.5**
  - `pandas` - Data manipulation & analysis
  - `numpy` - Numerical computing
  - `matplotlib` - Data visualization
  - `seaborn` - Statistical visualization

### Database & SQL
- **SQL Server**
  - CROSS APPLY, STRING_SPLIT
  - GROUP BY, ORDER BY, WHERE clauses
  - Window functions (SUM OVER)
  - Aggregate functions (COUNT, AVG, MIN, MAX)

### Tools & Platforms
- **Jupyter Notebook** - Interactive analysis
- **PowerPoint** - Presentation creation
- **Word Document** - Report writing
- **GitHub** - Version control & documentation

---

## 📁 File Structure

```
netflix-eda/
│
├── README.md                          # Project documentation
├── netflix_titles.csv                 # Raw dataset (8,807 records)
├── EDA_Analysis.ipynb                 # Python analysis notebook
│
├── sql_queries/
│   ├── query_1_content_distribution.sql
│   ├── query_2_top_countries.sql
│   ├── query_3_content_timeline.sql
│   ├── query_4_rating_distribution.sql
│   ├── query_5_movie_duration.sql
│   ├── query_6_release_gap_analysis.sql
│   ├── query_7_top_genres.sql
│   └── query_8_director_analysis.sql
│
├── outputs/
│   ├── Netflix_EDA_Analysis.docx      # Comprehensive report
└── images/
    ├── content_distribution.png
    ├── geographic_trends.png
    ├── temporal_growth.png
    └── rating_analysis.png
```
## 🚀 How to Run

### Prerequisites
```bash
# Install required libraries
pip install pandas numpy matplotlib seaborn jupyter
```

### Step 1: Clone Repository
```bash
git clone https://github.com/Ranjan234/netflix-eda.git
cd netflix-eda
```

### Step 2: Load Data
```python
import pandas as pd

# Load dataset
df = pd.read_csv('netflix_titles.csv')
print(f"Dataset shape: {df.shape}")
print(df.head())
```

### Step 3: Data Cleaning
```python
# Check missing values
print(df.isnull().sum())

# Remove rows with null duration
df.dropna(subset=["duration"], inplace=True)

# Reset index
df.reset_index(drop=True, inplace=True)

print(f"Cleaned dataset shape: {df.shape}")  # (8804, 12)
```

### Step 4: Run Analysis
```python
# Example: Content distribution
content_dist = df['type'].value_counts()
print(content_dist)

# Example: Top countries
top_countries = df['country'].value_counts().head(10)
print(top_countries)
```

### Step 5: Run SQL Queries
```bash
# Execute SQL queries in SQL Server/MySQL
# See sql_queries/ folder for individual query files
```

---

## 📊 Results & Deliverables

### 1. Presentation Deck
- **File:** `Netflix_EDA_Analysis.pptx`
- **Slides:** 16 professional slides
- **Design:** Netflix-themed (red color scheme)
- **Content:** All 8 queries with visualizations & insights

### 2. Comprehensive Report
- **File:** `Netflix_EDA_Analysis.docx`
- **Pages:** 15+ detailed pages
- **Sections:** Dataset overview, cleaning process, all queries, insights, recommendations

### 3. Analysis Notebook
- **File:** `EDA_Analysis.ipynb`
- **Cells:** 50+ code cells with outputs
- **Visualizations:** Charts for temporal, geographic, and rating analysis

### 4. SQL Query Files
- **8 individual query files** with documentation
- **Ready to run** in SQL Server, MySQL, or PostgreSQL

---

## 📈 Key Findings Summary

| Finding | Data | Implication |
|---------|------|------------|
| **Movie Dominance** | 69.62% movies (6,131) | On-demand preference |
| **USA Market** | 32% of catalog (2,818) | Primary market focus |
| **Expansion Phase** | 2017-2020: +6,832 titles | Competitive response |
| **Mature Audience** | 75%+ TV-14+ | Adult targeting |
| **Drama Focus** | 27.6% dramas | Genre preference |
| **Global Content** | 46.5% international | Worldwide appeal |
| **Acquisition Gap** | TV: 2yr, Movies: 5yr | Different strategies |
| **Creator Diversity** | Max 2 titles/director | Portfolio approach |


## 🤝 Contributing

Contributions are welcome! Please feel free to:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## 👨‍💻 Author

**Your Name**
- Email: soumyanalyst323@gmail.com.com
- LinkedIn: [SoumyaRanjanSahoo](https://www.linkedin.com/in/soumyaranjansahoo0/)
- GitHub: [Ranjan234](https://github.com/Ranjan234)

---

## 🙏 Acknowledgments

- Netflix for the public dataset
- Inspiration from data analysis community
- Special thanks to all contributors

---

## 📞 Questions & Support

For questions or issues:
1. Open an issue on GitHub
2. Check existing issues first
3. Provide detailed description & steps to reproduce

---

## ⭐ If you found this project helpful, please consider giving it a star!

**Last Updated:** April 2026  
**Status:** ✅ Complete & Production Ready
