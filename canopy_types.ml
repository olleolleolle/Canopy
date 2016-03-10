type article = {
  title : string;
  content : string;
  author : string;
  abstract : string option;
  uri : string;
}

let meta_assoc str =
  Re_str.split (Re_str.regexp "\n") str |>
  List.map (fun meta ->
      let reg = Re_str.regexp "\\(.*\\): \\(.*\\)" in
      let _ = Re_str.string_match reg meta 0 in
      let key = Re_str.matched_group 1 meta in
      let value = Re_str.matched_group 2 meta in
      key, value)

let article_of_string uri str =
  try
    let r_meta = Re_str.regexp "---" in
    let s_str = Re_str.split r_meta str in
    match s_str with
    | [meta; content] ->
      let assoc = meta_assoc meta in
      let author = List.assoc "author" assoc in
      let title = List.assoc "title" assoc in
      let abstract =
        try
          Some (List.assoc "abstract" assoc)
        with
        | Not_found -> None in
      Some {title; content; author; uri; abstract}
    | _ -> None
  with
  | _ -> None