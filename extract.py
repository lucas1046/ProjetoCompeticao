import pandas as pd
import json

file_path = r'C:\Users\lucas\OneDrive - Centro Paula Souza\Lab de Eng de Software\Copy of COPA SKILL 2025.xlsx'
df = pd.read_excel(file_path, sheet_name='RODADAS - COMPLETO')

matches = {}

def parse_int(val):
    if pd.isna(val):
        return None
    try:
        return int(float(val))
    except (ValueError, TypeError):
        return None

for index, row in df.iterrows():
    if pd.isna(row['RODADA']) or pd.isna(row['MANDANTE']) or pd.isna(row['VISITANTE']):
        continue

    data_val = row['DATA']
    if pd.notnull(data_val):
        # some dates might be timestamp, let's keep them as string, but nicely formatted if they are datetime
        if isinstance(data_val, pd.Timestamp):
            data_str = data_val.strftime('%Y-%m-%d %H:%M')
        else:
            data_str = str(data_val)
    else:
        data_str = "2025-01-01"

    rodada = str(row['RODADA']).strip()
    cat = str(row['CATEGORIA']).strip()
    mandante = str(row['MANDANTE']).strip()
    visitante = str(row['VISITANTE']).strip()

    match_key = (data_str, rodada, cat, mandante, visitante)

    if match_key not in matches:
        matches[match_key] = {
            "data": data_str,
            "rodada": rodada,
            "categoria": cat,
            "mandante": mandante,
            "visitante": visitante,
            "escalacao_casa": [],
            "escalacao_visitante": []
        }

    # Casa
    jogador_casa = row.get('JOGADORES')
    if pd.notna(jogador_casa) and str(jogador_casa).strip() != "":
        matches[match_key]['escalacao_casa'].append({
            "nome": str(jogador_casa).strip(),
            "camisa": parse_int(row.get('CAMISA')),
            "gols": parse_int(row.get('GOLS')) or 0,
            "cartao": str(row.get('CARTÃO')).strip() if pd.notna(row.get('CARTÃO')) else None
        })

    # Visitante
    jogador_vis = row.get('JOGADORES.1')
    if pd.notna(jogador_vis) and str(jogador_vis).strip() != "":
        matches[match_key]['escalacao_visitante'].append({
            "nome": str(jogador_vis).strip(),
            "camisa": parse_int(row.get('CAMISA.1')),
            "gols": parse_int(row.get('GOLS.1')) or 0,
            "cartao": str(row.get('CARTÃO.1')).strip() if pd.notna(row.get('CARTÃO.1')) else None
        })

matches_list = list(matches.values())

with open('assets/planilha_copa.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

data['partidas'] = matches_list

with open('assets/planilha_copa.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=1)

print(f"Added {len(matches_list)} matches to planilha_copa.json")
