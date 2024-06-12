# :bird: Pterodactyl Kurulum Betiği


# Henüz hazır değildir!



![Test Panel](https://github.com/pterodactyl-installer/pterodactyl-installer/actions/workflows/panel.yml/badge.svg)
![Test Wings](https://github.com/pterodactyl-installer/pterodactyl-installer/actions/workflows/wings.yml/badge.svg)
![Shellcheck](https://github.com/pterodactyl-installer/pterodactyl-installer/actions/workflows/shellcheck.yml/badge.svg)
[![License: GPL v3](https://img.shields.io/github/license/pterodactyl-installer/pterodactyl-installer)](LICENSE)
[![Discord](https://img.shields.io/discord/682342331206074373?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://pterodactyl-installer.se/discord)
[![made-with-bash](https://img.shields.io/badge/-Made%20with%20Bash-1f425f.svg?logo=image%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw%2FeHBhY2tldCBiZWdpbj0i77u%2FIiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8%2BIDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTExIDc5LjE1ODMyNSwgMjAxNS8wOS8xMC0wMToxMDoyMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkE3MDg2QTAyQUZCMzExRTVBMkQxRDMzMkJDMUQ4RDk3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkE3MDg2QTAzQUZCMzExRTVBMkQxRDMzMkJDMUQ4RDk3Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6QTcwODZBMDBBRkIzMTFFNUEyRDFEMzMyQkMxRDhEOTciIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6QTcwODZBMDFBRkIzMTFFNUEyRDFEMzMyQkMxRDhEOTciLz4gPC9yZGY6RGVzY3JpcHRpb24%2BIDwvcmRmOlJERj4gPC94OnhtcG1ldGE%2BIDw%2FeHBhY2tldCBlbmQ9InIiPz6lm45hAAADkklEQVR42qyVa0yTVxzGn7d9Wy03MS2ii8s%2BeokYNQSVhCzOjXZOFNF4jx%2BMRmPUMEUEqVG36jo2thizLSQSMd4N8ZoQ8RKjJtooaCpK6ZoCtRXKpRempbTv5ey83bhkAUphz8fznvP8znn%2B%2F3NeEEJgNBoRRSmz0ub%2FfuxEacBg%2FDmYtiCjgo5NG2mBXq%2BH5I1ogMRk9Zbd%2BQU2e1ML6VPLOyf5tvBQ8yT1lG10imxsABm7SLs898GTpyYynEzP60hO3trHDKvMigUwdeaceacqzp7nOI4n0SSIIjl36ao4Z356OV07fSQAk6xJ3XGg%2BLCr1d1OYlVHp4eUHPnerU79ZA%2F1kuv1JQMAg%2BE4O2P23EumF3VkvHprsZKMzKwbRUXFEyTvSIEmTVbrysp%2BWr8wfQHGK6WChVa3bKUmdWou%2BjpArdGkzZ41c1zG%2Fu5uGH4swzd561F%2BuhIT4%2BLnSuPsv9%2BJKIpjNr9dXYOyk7%2FBZrcjIT4eCnoKgedJP4BEqhG77E3NKP31FO7cfQA5K0dSYuLgz2TwCWJSOBzG6crzKK%2BohNfni%2Bx6OMUMMNe%2Fgf7ocbw0v0acKg6J8Ql0q%2BT%2FAXR5PNi5dz9c71upuQqCKFAD%2BYhrZLEAmpodaHO3Qy6TI3NhBpbrshGtOWKOSMYwYGQM8nJzoFJNxP2HjyIQho4PewK6hBktoDcUwtIln4PjOWzflQ%2Be5yl0yCCYgYikTclGlxadio%2BBQCSiW1UXoVGrKYwH4RgMrjU1HAB4vR6LzWYfFUCKxfS8Ftk5qxHoCUQAUkRJaSEokkV6Y%2F%2BJUOC4hn6A39NVXVBYeNP8piH6HeA4fPbpdBQV5KOx0QaL1YppX3Jgk0TwH2Vg6S3u%2BdB91%2B%2FpuNYPYFl5uP5V7ZqvsrX7jxqMXR6ff3gCQSTzFI0a1TX3wIs8ul%2Bq4HuWAAiM39vhOuR1O1fQ2gT%2F26Z8Z5vrl2OHi9OXZn995nLV9aFfS6UC9JeJPfuK0NBohWpCHMSAAsFe74WWP%2BvT25wtP9Bpob6uGqqyDnOtaeumjRu%2ByFu36VntK%2FPA5umTJeUtPWZSU9BCgud661odVp3DZtkc7AnYR33RRC708PrVi1larW7XwZIjLnd7R6SgSqWSNjU1B3F72pz5TZbXmX5vV81Yb7Lg7XT%2FUXriu8XLVqw6c6XqWnBKiiYU%2BMt3wWF7u7i91XlSEITwSAZ%2FCzAAHsJVbwXYFFEAAAAASUVORK5CYII%3D)](https://www.gnu.org/software/bash/)

Pterodactyl Panel ve Wings için resmi olmayan kurma betiği. Her zaman Pterodactyl'in son sürümü ile çalışır.

Buradan daha fazlasını okuyabilirsin: [Pterodactyl](https://pterodactyl.io/). Bu reponun orijinal Pterodactyl Projesi ile bağıntısı yoktur.

## Özellikler

- Otomatik Pterodactyl Panel kurulumu (bağımlılıklar, veritabanı, cronjob, nginx).
- Otomatik Pterodactyl Wings kurulumu (Docker, systemd).
- Panel: (opsiyonel) Otomatik Let's Encrypt konfigürasyonu.
- Panel: (opsiyonel) Otomatik Güvenlik Duvarı konfigürasyonu.
- Panel ve Wings kaldırma desteği.

## Yardım ve Destek

**Resmi Pterodactyl projesi** ile bağıntılı değil, betik ile ilgili yardım ve destek için [Discord Chat](https://pterodactyl-installer.se/discord) adresine katılabilirsiniz.

## Desteklenen Sistemler

Panel ve Wings için desteklenen sistemlerinin listesi (bu kurulum betiği tarafından desteklenen sistemler).

### Supported panel and wings operating systems

| İşletim Sistemi  | Versiyon| Destekliyor mu?    | PHP Versiyon|
| ---------------- | ------- | ------------------ | ----------- |
| Ubuntu           | 14.04   | :red_circle:       |             |
|                  | 16.04   | :red_circle: \*    |             |
|                  | 18.04   | :red_circle: \*    | 8.1         |
|                  | 20.04   | :white_check_mark: | 8.1         |
|                  | 22.04   | :white_check_mark: | 8.1         |
| Debian           | 8       | :red_circle: \*    |             |
|                  | 9       | :red_circle: \*    |             |
|                  | 10      | :white_check_mark: | 8.1         |
|                  | 11      | :white_check_mark: | 8.1         |
|                  | 12      | :white_check_mark: | 8.1         |
| CentOS           | 6       | :red_circle:       |             |
|                  | 7       | :red_circle: \*    |             |
|                  | 8       | :red_circle: \*    |             |
| Rocky Linux      | 8       | :white_check_mark: | 8.1         |
|                  | 9       | :white_check_mark: | 8.1         |
| AlmaLinux        | 8       | :white_check_mark: | 8.1         |
|                  | 9       | :white_check_mark: | 8.1         |

_\* Indicates an operating system and release that previously was supported by this script._

## Kurulum Betiğinin Kullanımı

Kurulum betiklerini kullanmak için bu komutu root olarak çalıştırmanız yeterlidir. Betik size sadece paneli mi, sadece Wings'i mi yoksa her ikisini de mi kurmak istediğinizi soracaktır.

```bash
bash <(curl -s https://pterodactyl-installer.se)
```

_Not: Bazı sistemlerde, tek satırlık komutu çalıştırmadan önce root olarak oturum açmış olmanız gerekir (komutun önünde `sudo` varsa çalışmaz)._

İşte kurulum sürecini gösteren bir [YouTube videosu](https://www.youtube.com/watch?v=E8UJhyUFoHM).

## Güvenlik Duvarı Kurulumu

Kurulum komut dosyaları sizin için bir güvenlik duvarı kurabilir ve yapılandırabilir. Komut dosyası bunu isteyip istemediğinizi soracaktır. Otomatik güvenlik duvarı kurulumunu tercih etmeniz önemle tavsiye edilir.

## Geliştirme ve Operasyon

### Komut dosyasını yerel olarak test etme

Betiği test etmek için [Vagrant](https://www.vagrantup.com) kullanıyoruz. Vagrant ile, betiği test etmek için hızlı bir şekilde yeni bir makine kurabilir ve çalıştırabilirsiniz.

Betiği desteklenen tüm sistemlerde tek seferde test etmek istiyorsanız, aşağıdakileri çalıştırmanız yeterlidir.

```bash
vagrant up
```

Yalnızca belirli bir desteklenen sistemler test etmek istiyorsanız, aşağıdakileri çalıştırabilirsiniz.

```bash
vagrant up <name>
```

Adı aşağıdakilerden biriyle değiştirin (desteklenen sistemler).

- `ubuntu_jammy`
- `ubuntu_focal`
- `debian_bullseye`
- `debian_buster`
- `debian_bookworm`
- `almalinux_8`
- `almalinux_9`
- `rockylinux_8`
- `rockylinux_9`

Daha sonra kutuya SSH ile bağlanmak için `vagrant ssh <makine adı>` kullanabilirsiniz. Proje dizini `/vagrant` dizinine bağlanacaktır, böylece betiği yerel olarak hızlı bir şekilde değiştirebilir ve ardından betiği sırasıyla `/vagrant/installers/panel.sh` ve `/vagrant/installers/wings.sh` adreslerinden çalıştırarak değişiklikleri test edebilirsiniz.

### Bir sürüm oluşturma

Install.sh` dosyasında github kaynağı ve betik sürüm değişkenleri her sürümde değişmelidir. İlk olarak, `CHANGELOG.md` dosyasını güncelleyin, böylece yayın tarihi ve yayın etiketinin her ikisi de görüntülenir. Değişiklik günlüğü noktalarının kendisinde herhangi bir değişiklik yapılmamalıdır. İkinci olarak, `install.sh` dosyasındaki `GITHUB_SOURCE` ve `SCRIPT_RELEASE` dosyalarını güncelleyin. Son olarak, artık `Release vX.Y.Z` mesajıyla bir commit gönderebilirsiniz. GitHub üzerinde bir sürüm oluşturun. Referans için [this commit](https://github.com/pterodactyl-installer/pterodactyl-installer/commit/90aaae10785f1032fdf90b216a4a8d8ca64e6d44) adresine bakın.

## Katkıda Bulunanlar ✨

Telif hakları saklıdır. (C) 2018 - 2024, Vilhelm Prytz, <vilhelm@prytznet.se>, ve katkıda bulunanlar!

- Sahibi: [Vilhelm Prytz](https://github.com/vilhelmprytz)
- Geliştiren: [Linux123123](https://github.com/Linux123123)
- Türkçeleştiren: [CaglarYml](https://github.com/CaglarYml)

Discord moderatörleri [sam1370](https://github.com/sam1370), [Linux123123](https://github.com/Linux123123) ve [sinjs](https://github.com/sinjs)'e Discord sunucusundaki yardımları için teşekkürler!
Katkıda Bulunanlar:
