
Slide Generation Template v1.1 (YAML)
# ========================================

# Slide Generation Template v1.1: {{ slide_meta.course_title }}_{{ slide_meta.module_no }}_{{ slide_meta.slide_no | default('XX') }}

#

# このテンプレートは、オンラインコース用スライド生成のためのパラメータを定義します。

# 以下の情報ソースからの入力を統合することを想定しています:

# 1. コース構成情報 (slide_meta, dynamic_content)

# 2. スライドごとのコンテンツ指示 (content)

# 3. 事前定義されたレイアウト・デザインプリセット (design_style.preset)

# 4. ユーザーによる個別デザイン調整指示 (design_style.custom)

# 5. 参照画像や生成AIへの指示 (visuals)

# 6. ブランドガイドライン/アセット情報 (brand_assets)

# 7. 過去のフィードバックや調整履歴 (user_feedback_intent)

# ========================================

# === Slide Meta Information ===

# スライドの基本的な属性、コース内での位置づけを定義。

slide_meta:

  course_title: "シュンスケ式バイブコーディング" # 必須: コースの正式名称

  module_no: "M1"                              # 必須: モジュール番号 (例: M1, M2)

  module_name: "イントロダクションとマインドセット" # 任意: モジュール名

  slide_no: "S3"                               # 任意: スライド番号 (例: S1, S2, S3)

  slide_purpose: "バイブコーディングの核心思想を伝える" # 必須: このスライドが果たすべき役割・目的

# === Dynamic Content ===

# スライドテンプレート内で動的に変更・挿入される可能性のあるテキスト要素。

dynamic_content:

  lesson_title: "バイブコーディングの核心思想" # 例: レッスンタイトル

  instructor_name: "林 俊介"                 # 例: 講師名 (フッター等で使用する場合)

  current_date: "{{ date_placeholder }}"       # 例: 講義日など (プレースホルダー、システムで置換想定)

# === Content ===

# スライドに表示される主要なテキストコンテンツ。

content:

  headline: "バイブコーディング 3つの核心"    # 必須: スライドのメインタイトル/見出し

  sub_headline: "完璧主義よりフローを重視！" # 任意: 見出しを補足するサブタイトル

  body_text: |                             # 任意: 主要な説明文 (複数行、マークダウン可)

    AI時代を生き抜くための新しい開発スタイル、

    それが「バイブコーディング」です。

    大切にするのは以下の3つのポイントです。

  bullet_points:                           # 任意: 箇条書きリスト

    - title: "1. ノリと勢い"                 # 箇条書きのタイトル (任意)

      text: "完璧を目指さず、まず動かすことを最優先。" # 箇条書きの本文

    - title: "2. AI = 対話パートナー"

      text: "指示・確認・改良のサイクルでAIと共同開発。"

    - title: "3. ログドリブン"

      text: "対話ログを記録・活用し、継続的に改善する。"

  emphasized_keywords: ["フロー重視", "共同開発", "ログ活用"] # 任意: 特に強調したいキーワード

  call_to_action:                          # 任意: 行動喚起

    text: "次のレッスンで詳しく見ていきましょう！"

    button_label: "次へ進む"                # 任意: ボタンテキスト

# === Layout ===

# スライドの構造、要素の配置を指定。

layout:

  type: "3分割テキスト＋アイコン" # 必須: レイアウトタイプを指定 (例: タイトルのみ, 左画像＋右テキスト, 3ステップ表示, 比較表)

  # layout_options: # タイプに応じたオプション (任意)

  #   image_position: "left"

  #   text_alignment: "center"

  #   column_count: 3

# === Visuals ===

# スライドに使用する画像、図、アイコンなどの視覚要素。

visuals:

  # --- 主なビジュアルタイプ ---

  type: "icon_set" # 必須: ('image_generation', 'diagram_generation', 'icon_set', 'reference_image', 'none')

  # --- 画像生成の場合 (type: 'image_generation') ---

  image_generation_prompt: | # 画像生成AIへの指示プロンプト

    モダンで抽象的な背景。ゴールド(#D4A127)とダークグレー(#333333)の幾何学模様が流れるように配置され、中心に明るい光が集まるイメージ。プロフェッショナルかつ未来的な雰囲気。アスペクト比16:9。

  # image_style_reference: "" # 任意: スタイル参照画像ID/URL

  # --- 図生成の場合 (type: 'diagram_generation') ---

  diagram_description: | # 生成したい図の説明

    3つの円（ノリと勢い、AI対話、ログドリブン）が相互に矢印で繋がり、サイクルを形成しているシンプルな図。色はブランドカラーのゴールドとダークグレーを使用。

  # diagram_type: "cycle_diagram" # 任意: 図の種類 (例: flow_chart, mind_map)

  # --- アイコンセットの場合 (type: 'icon_set') ---

  icon_list: # 使用するアイコンのリスト

    - name: "rocket" # アイコン名 (Font Awesome等) または内容の説明

      target_element: "bullet_point_1_title" # 関連付ける要素 (例: headline, bullet_point_1)

    - name: "comments"

      target_element: "bullet_point_2_title"

    - name: "history"

      target_element: "bullet_point_3_title"

  # icon_style: "line_icon_gold" # 任意: アイコンのスタイル (例: solid_darkgrey, line_icon_gold)

  # --- 参照画像の場合 (type: 'reference_image') ---

  # reference_image_id: "IMG-01.png" # 必須: 使用する画像のIDやパス

  # image_placement: "background_fill" # 任意: 配置方法 (例: top_right, background_fill)

# === Design Style ===

# スライド全体のデザインに関する指示。presetとcustomで構成。

design_style:

  # --- Preset ---

  # 事前定義されたデザインテーマやスタイルを指定。

  preset:

    name: "Shunsuke_VibeCoding_Default" # 例: コース共通のデフォルトプリセット

    # detail: # プリセットに含まれる詳細 (システムが読み込む or 参考用)

    #   overall_mood: "Professional yet approachable"

    #   color_palette_name: "Gold_Darkgrey"

    #   font_pairing: "Playfair_NotoSansJP"

  # --- Custom Adjustments ---

  # presetの設定を上書き・微調整するためのユーザー指示。

  # 空欄の場合はpresetの値が適用される。

  custom:

    overall_mood: "" # 例: "More energetic"

    # --- Colors ---

    color_scheme:

      background: "" # 例: "#F8F8F8"

      headline_color: "" # 例: "#D4A127"

      body_text_color: "" # 例: "#555555"

    # --- Typography ---

    typography:

      headline_font_size: "48pt" # 例: "large", "48pt"

      body_font_size: "24pt"

      # headline_font_weight: "bold"

    # --- Layout Spacing ---

    # element_spacing: "loose" # 例: "tight", "standard", "loose"

    # --- Effects ---

    # headline_underline: "gold_thin_line" # 例: "none", "gold_thin_line"

# === Brand Assets ===

# コース共通のブランド要素。

brand_assets:

  logo_path: "shunsuke_vc_logo.svg" # 任意: ロゴファイルパス

  # logo_placement: "bottom_right" # 任意: ロゴ配置場所

  primary_font: "Playfair Display" # 必須: 主要フォント

  secondary_font: "Noto Sans JP" # 必須: 補助フォント

  brand_colors: # 必須: ブランドカラーパレット

    gold: "#D4A127"

    darkgrey: "#333333"

    white: "#FFFFFF"

    offwhite: "#FCF9F5"

# === User Feedback Intent ===

# ユーザーからの修正指示や調整意図を記録。次回生成時に参照される。

user_feedback_intent: |

  # 例:

  # - User Input: "箇条書きのアイコンをもっと大きくして"

  #   Intent: Increase icon size for bullet points

  #   Mapped Parameter: visuals.icon_size="36pt" (仮)

  # - User Input: "背景をもう少し明るくできませんか？"

  #   Intent: Brighten background color

  #   Mapped Parameter: design_style.custom.color_scheme.background="#FFFFF0"

  pass # 初期状態では空



このYAMLテンプレートのポイント:

構造化: 広告クリエイティブの例と同様に、セクション分け（slide_meta, content, layout, visuals, design_style, brand_assets, user_feedback_intent）を行い、パラメータを階層的に整理しました。
具体性: 各パラメータにコメントで説明を加え、# 例: で具体的な値を示しました。これにより、AIだけでなく人間も理解しやすくなります。
スライド特化: slide_purpose, bullet_points, layout.type, visuals（画像/図/アイコンの選択）など、スライド作成に特有の要素を盛り込みました。
カスタマイズ性: design_style を preset と custom に分け、基本スタイルを維持しつつ個別の調整を可能にしました。dynamic_content でスライド間で変化する要素に対応します。
AI連携: visuals セクションには、画像生成AIや図生成AIへの指示プロンプトを直接記述できるようにしました。user_feedback_intent で改善ループをサポートします。
ブランド一貫性: brand_assets でコース共通のロゴ、フォント、色を指定し、デザインの一貫性を保ちます。

このテンプレートをベースに、各スライドの内容に合わせてパラメータを埋めていくことで、より効率的かつ高品質なスライド生成が期待できます。AIへの指示も明確になり、意図した通りのアウトプットを得やすくなるでしょう。

