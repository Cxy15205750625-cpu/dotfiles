;;; -*- lexical-binding: t; -*-

;; 包管理
;; 缺少软件包时，用 M-x package-install 手动安装。
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; Custom 与主题
;; 初始化软件包后再加载 Custom，才能找到其中启用的 gruber-darker 主题。
(setq custom-file "~/.emacs.custom")
(load custom-file t)

;; 用个人配色覆盖主题，重新启用主题时注释也保持淡灰色。
(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "#858585" :box nil))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#858585" :box nil)))))

;; 字体与窗口
;; 默认使用 Comic Mono 20 号，text-mode 启用 Comic Sans MS 比例字体。
(add-to-list 'default-frame-alist '(font . "Comic Mono-20"))
(set-face-attribute 'variable-pitch nil :family "Comic Sans MS")
(set-face-attribute 'fixed-pitch nil :family "Comic Mono")
(add-hook 'text-mode-hook #'variable-pitch-mode)

;; 新窗口默认 80 列、35 行。
(add-to-list 'default-frame-alist '(width . 80))
(add-to-list 'default-frame-alist '(height . 35))

;; 图形界面隐藏工具栏、菜单栏和滚动条。
(when (display-graphic-p)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

;; 行号、当前行高亮与光标
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)

;; 启用 hl-line 后设置当前行底色。
(set-face-attribute 'hl-line nil :background "#242424")

;; 方块光标。想用 2 像素宽的竖线，可以改为 '(bar . 2)。
(setq-default cursor-type 'box)

;; 图形界面使用白色光标，lolipop 沿用这个颜色。
(when (display-graphic-p)
  (add-to-list 'default-frame-alist '(cursor-color . "#FFFFFF"))
  (set-frame-parameter nil 'cursor-color "#FFFFFF"))

;; 只在选中的窗口显示光标，设置闪烁延迟和间隔。
(setq cursor-in-non-selected-windows nil
      blink-cursor-interval 0.6
      blink-cursor-delay 0.3)
(blink-cursor-mode 1)

;; 自动保存与备份
;; 空闲 2 秒后，将改动写回原文件。
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 2)

;; 空闲 15 秒或每 100 次输入事件生成恢复副本，可用 M-x recover-file 恢复。
(setq auto-save-timeout 15
      auto-save-interval 100)

;; 将恢复副本和版本备份分别放在 var/auto-save/ 和 var/backup/。
(let* ((base (expand-file-name "var/" user-emacs-directory))
       (auto-dir (expand-file-name "auto-save/" base))
       (backup-dir (expand-file-name "backup/" base)))
  (make-directory auto-dir t)
  (make-directory backup-dir t)
  (setq auto-save-file-name-transforms `((".*" ,auto-dir t))
        backup-directory-alist `(("." . ,backup-dir))
        backup-by-copying t      ; 复制文件来备份，保留原文件的链接
        version-control t        ; 保留多版本 foo.txt.~1~
        kept-new-versions 5
        kept-old-versions 1
        delete-old-versions t))


;; Company 补全
;; 装好 company 后才启用补全。
(require 'company nil t)

(when (featurep 'company)
  ;; 候选来自当前模式的 CAPF 和缓冲区中出现过的词。
  (setq company-idle-delay 0.2            ; 停 0.2 秒自动弹
        company-minimum-prefix-length 1   ; 打 1 个字符就弹
        company-selection-wrap-around t
        company-show-numbers t
        company-tooltip-align-annotations t
        company-backends '((company-capf company-dabbrev-code)
                           company-dabbrev))
  (global-company-mode 1)

  ;; 编程模式里的 TAB 有候选时接受补全，否则先缩进再触发补全。
  (defun my/tab-complete ()
    "TAB：有候选就接受；否则缩进后弹出补全。"
    (interactive)
    (if (company-active-p)
        (company-complete-selection)
      (indent-for-tab-command)
      (company-complete)))
  (define-key prog-mode-map (kbd "TAB") #'my/tab-complete)

  ;; 在候选框里用 C-n 和 C-p 上下选。
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(unless (featurep 'company)
  (message "company 未安装：联网后执行 M-x package-install RET company RET"))

;; lolipop 光标动画
;; 使用本机编译的 macOS 模块，编译步骤见包目录里的 README。
(add-to-list 'load-path "~/.emacs.d/site-lisp/lolipop")
(require 'lolipop-mode)
(lolipop-mode 1)

;; Magit 缓冲区禁用光标动画，避免重绘时闪烁。
(setq lolipop-filter-modes '(magit-mode magit-status-mode))

;; Ido 用于交互式选择文件和缓冲区。
(ido-mode 1)
(ido-everywhere 1)
