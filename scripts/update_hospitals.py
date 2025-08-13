import os
import re
from pathlib import Path

ROOT = Path('.').resolve()
STATE_DIRS = [ROOT / 'orthopaedics-NSW', ROOT / 'orthopaedics-QLD', ROOT / 'orthopaedics-VIC']

HOSPITALS = {
    'NSW': [
        ("https://campbelltownprivatehospital.com.au/services/orthopaedic-surgery", "Campbelltown Private Hospital"),
        ("https://huntervalleyprivatehospital.com.au/services/orthopaedic-surgery", "Hunter Valley Private Hospital"),
        ("https://nepeanprivatehospital.com.au/services/orthopaedic-surgery", "Nepean Private Hospital"),
        ("https://newcastleprivatehospital.com.au/services/orthopaedic-surgery", "Newcastle Private Hospital"),
        ("https://northernbeacheshospital.com.au/services/orthopaedic-surgery", "Northern Beaches Hospital"),
        ("https://norwestprivatehospital.com.au/services/orthopaedic-surgery", "Norwest Private Hospital"),
        ("https://princeofwalesprivatehospital.com.au/services/orthopaedic-surgery", "Prince of Wales Private Hospital"),
        ("https://sydneysouthwestprivatehospital.com.au/services/orthopaedic-surgery", "Sydney Southwest Private Hospital"),
    ],
    'QLD': [
        ("https://brisbaneprivatehospital.com.au/services/orthopaedic-surgery", "Brisbane Private Hospital"),
        ("https://goldcoastprivatehospital.com.au/services/orthopaedic-surgery", "Gold Coast Private Hospital"),
        ("https://peninsulaprivatehospital.com.au/services/orthopaedic-surgery", "Peninsula Private Hospital"),
        ("https://sunnybankprivatehospital.com.au/services/orthopaedic-surgery", "Sunnybank Private Hospital"),
    ],
    'VIC': [
        ("https://holmesglenprivatehospital.com.au/services/orthopaedic-surgery", "Holmesglen Private Hospital"),
        ("https://johnfawknerprivatehospital.com.au/services/orthopaedic-surgery", "John Fawkner Private Hospital"),
        ("https://knoxprivatehospital.com.au/services/orthopaedic-surgery", "Knox Private Hospital"),
        ("https://melbourneprivatehospital.com.au/services/orthopaedic-surgery", "Melbourne Private Hospital"),
        ("https://latrobeprivatehospital.com.au/services/orthopaedic-surgery", "La Trobe Private Hospital"),
        ("https://ringwoodprivatehospital.com.au/services/orthopaedic-surgery", "Ringwood Private Hospital"),
    ],
}

COL_DIV_TEMPLATE_START = (
    '<div class="col-lg-3 d-flex flex-column" data-aos="fade-up" data-aos-delay="200" '
    'style="display: block !important; float: left;">\n    <div style=\'clear:both\'></div>\n'
)
COL_DIV_TEMPLATE_END = '\n</div>'

LINK_TEMPLATE = (
    '    <a href="{href}" target="_blank" class="btn-read-more d-inline-flex align-items-center '
    'justify-content-center align-self-center"><span>{label}</span></a><br>\n'
)

ROW_WRAPPER_START = ''
ROW_WRAPPER_END = '\n'

HEADER_REGEX = re.compile(r'(?:<center>\s*)?<h3>\s*Our\s+Hospitals\s*</h3>.*?</center>\s*<center>.*?</center>', re.IGNORECASE | re.DOTALL)
ROW_GX0_REGEX = re.compile(r'<div class=\"row gx-0\"[^>]*>', re.IGNORECASE)


def split_into_four_columns(items):
    n = len(items)
    base = n // 4
    rem = n % 4
    sizes = [base + (1 if i < rem else 0) for i in range(4)]
    cols = []
    idx = 0
    for size in sizes:
        cols.append(items[idx: idx + size])
        idx += size
    return cols


def build_columns_html(items):
    cols = split_into_four_columns(items)
    parts = []
    for col_items in cols:
        html = [COL_DIV_TEMPLATE_START]
        for href, label in col_items:
            html.append(LINK_TEMPLATE.format(href=href, label=label))
        html.append(COL_DIV_TEMPLATE_END)
        parts.append(''.join(html))
    return ROW_WRAPPER_START + ''.join(parts) + ROW_WRAPPER_END


def update_file(file_path: Path, state_key: str) -> bool:
    content = file_path.read_text(encoding='utf-8', errors='ignore')

    m = HEADER_REGEX.search(content)
    if not m:
        return False

    header_end = m.end()
    m_end = ROW_GX0_REGEX.search(content, header_end)
    if not m_end:
        return False

    new_block = build_columns_html(HOSPITALS[state_key])

    new_content = content[:header_end] + new_block + content[m_end.start():]
    if new_content != content:
        file_path.write_text(new_content, encoding='utf-8')
        return True
    return False


def main():
    total = 0
    changed = 0
    for state_dir in STATE_DIRS:
        if not state_dir.exists():
            continue
        state_key = 'NSW' if 'NSW' in state_dir.name else 'QLD' if 'QLD' in state_dir.name else 'VIC'
        for file_path in state_dir.glob('*.html'):
            total += 1
            try:
                if update_file(file_path, state_key):
                    changed += 1
                    print(f"Updated: {file_path}")
            except Exception as e:
                print(f"Error updating {file_path}: {e}")
    print(f"Done. Examined {total} files. Updated {changed} files.")


if __name__ == '__main__':
    main() 