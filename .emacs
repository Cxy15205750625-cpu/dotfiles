;;; -*- lexical-binding: t; -*-

;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ .emacs —— 我的 Emacs 配置                                      ┃
;; ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
;; ┃ 1. 包管理与加载      2. 字体与窗口                             ┃
;; ┃ 3. 主题与语法高亮    4. 光标与高亮                             ┃
;; ┃ 5. 自动保存与备份    6. 补全（company）                        ┃
;; ┃ 7. 光标动画：lolipop                                           ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ 1. 包管理与加载顺序                                            ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; 作用：决定 Emacs 从哪些软件源装包，以及 Custom 生成的东西存在哪。
;; 改动时机：想加软件源，或想改 Custom 文件的位置时。

;; 软件源：gnu（官方）、nongnu（官方扩展）、melpa（第三方，包最多）。
;; 本文件不在启动时联网装包，缺包就手动 M-x package-install，启动不会卡住。
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; 必须放在 package-initialize 之后：主题 gruber-darker 是包里的文件，
;; 包还没加载时启用主题会报 “Failed to enable theme(s)”。
;; Custom 生成的变量单独存一个文件，本文件只负责加载。
(setq custom-file "~/.emacs.custom")
(load custom-file t)


;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ 2. 字体与窗口                                                  ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; 作用：字体、窗口大小、界面元素开关。
;; 改动时机：想换字体/字号，或觉得窗口太挤的时候。

;; 等宽字体用 Comic Mono 20 号；text-mode 换成比例字体 Comic Sans。
(add-to-list 'default-frame-alist '(font . "Comic Mono-20"))
(set-face-attribute 'variable-pitch nil :family "Comic Sans MS")
(set-face-attribute 'fixed-pitch nil :family "Comic Mono")
(add-hook 'text-mode-hook #'variable-pitch-mode)

;; New windows 80 x 35 
(add-to-list 'default-frame-alist '(width . 80))
(add-to-list 'default-frame-alist '(height . 35))

;; 关掉工具栏、菜单栏、滚动条
;; （用 display-graphic-p 包一层：终端里没有这些，直接调用会报错）
(when (display-graphic-p)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ 4. 光标与高亮                                                  ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; 作用：行号、当前行高亮、光标形状/颜色、跳转后的视觉反馈。
;; 改动时机：想换光标样式时，只改下面“光标形状”那两行就够。

;; 行号 + 当前行高亮
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)

;; 当前行底色（hl-line 这个 face 要等 global-hl-line-mode 加载后才有）
(set-face-attribute 'hl-line nil :background "#242424")

;; 光标形状：细竖线。想回方块改成 'box；想更粗用 '(bar . 2)
(setq-default cursor-type 'box)

;; 光标颜色：纯白，果冻动画沿用这个颜色（只影响图形界面）
(when (display-graphic-p)
  (add-to-list 'default-frame-alist '(cursor-color . "#FFFFFF"))
  (set-frame-parameter nil 'cursor-color "#FFFFFF"))

;; 只有当前窗口显示光标；闪烁放慢一点，不刺眼
(setq cursor-in-non-selected-windows nil
      blink-cursor-interval 0.6
      blink-cursor-delay 0.3)
(blink-cursor-mode 1)

;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ 5. 自动保存与备份                                              ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; 作用：边打边存 + 崩溃保险，并把临时文件和备份挪出项目目录。
;; 改动时机：嫌写盘太频繁就加大 auto-save-visited-interval。

;; ① 停手 2 秒直接写回原文件（类似 VS Code 的自动保存）
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 2)

;; ② 崩溃保险：空闲 15 秒或每 100 次按键存一份 #文件#，崩溃后 M-x recover-file
(setq auto-save-timeout 15
      auto-save-interval 100)

;; 临时文件 → ~/.emacs.d/var/auto-save/，备份 → ~/.emacs.d/var/backup/
(let* ((base (expand-file-name "var/" user-emacs-directory))
       (auto-dir (expand-file-name "auto-save/" base))
       (backup-dir (expand-file-name "backup/" base)))
  (make-directory auto-dir t)
  (make-directory backup-dir t)
  (setq auto-save-file-name-transforms `((".*" ,auto-dir t))
        backup-directory-alist `(("." . ,backup-dir))
        backup-by-copying t      ; macOS 上别破坏硬链接/符号链接
        version-control t        ; 保留多版本 foo.txt.~1~
        kept-new-versions 5
        kept-old-versions 1
        delete-old-versions t))


;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ 6. 补全（company）                                             ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; 作用：打字时弹出候选框，TAB 选候选；只补“文件里出现过的词 + 已加载的函数名”，
;;       不接 LSP、不联网、不猜类型。
;; 依赖：company。没装时整段会被跳过，启动不会报错。
;; 装法：M-x package-install RET company RET（需要能访问软件源）

(require 'company nil t)

(when (featurep 'company)
  ;; 候选来源：capf（Emacs Lisp 的函数/变量、TAGS）+ 缓冲区里出现过的词
  (setq company-idle-delay 0.2            ; 停 0.2 秒自动弹
        company-minimum-prefix-length 1   ; 打 1 个字符就弹
        company-selection-wrap-around t
        company-show-numbers t
        company-tooltip-align-annotations t
        company-backends '((company-capf company-dabbrev-code)
                           company-dabbrev))
  (global-company-mode 1)

  ;; TAB：补全框开着就接受候选；没开就先正常缩进，再手动弹出补全
  (defun my/tab-complete ()
    "TAB：有候选就接受；否则缩进后弹出补全。"
    (interactive)
    (if (company-active-p)
        (company-complete-selection)
      (indent-for-tab-command)
      (company-complete)))
  (define-key prog-mode-map (kbd "TAB") #'my/tab-complete)

  ;; 候选框里用 C-n / C-p 上下选（默认是 M-n / M-p）
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(unless (featurep 'company)
  (message "company 未安装：联网后执行 M-x package-install RET company RET"))

;; ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;; ┃ 7. 光标动画：lolipop                                           ┃
;; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

;; 作用：让光标像果冻一样滑到新位置（CoreAnimation 原生实现，只支持 macOS）。
;; 包本体在 ~/.emacs.d/site-lisp/lolipop/，重新编译见该目录同级的 README 说明。

(add-to-list 'load-path "~/.emacs.d/site-lisp/lolipop")
(require 'lolipop-mode)
(lolipop-mode 1)

;; 这些模式下不画动画（magit 之类频繁重绘的场景容易闪）
(setq lolipop-filter-modes '(magit-mode magit-status-mode))

(ido-mode 1)
(ido-everywhere 1)
