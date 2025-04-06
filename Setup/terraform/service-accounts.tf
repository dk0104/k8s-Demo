resource "yandex_iam_service_account" "denk-sa" {
  name = "denk-sa"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.denk-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.denk-sa,
  ]
}

resource "yandex_iam_service_account_static_access_key" "static-access-key" {
  service_account_id = yandex_iam_service_account.denk-sa.id
  depends_on = [
    yandex_iam_service_account.denk-sa,
  ]
}
