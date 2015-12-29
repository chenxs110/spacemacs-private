;;; Package --- chenxuesong private fucntion
;;; Commentary:
;;; Code:

(setq chenxueosng-blog-dir "~/Work/blog/")
(defun chenxuesong-review-code-post-g (args)
  "Review with rbt post -g."
  (interactive "P")
  (let ((default-directory (concat (magit-git-dir)
                                   "/../")) output)
    (setq output (shell-command-to-string "rbt post -g"))
    (if (string-match "http://.+" output)
        (browse-url (substring output
                               (match-beginning 0)
                               (match-end 0)))
      (message output))))

(defun chenxuesong-review-code-post-r (review-id)
  "Review with rbt post -r id."
  (interactive "sWhich review your want again? ")
  (let ((default-directory (concat (magit-git-dir)
                                   "/../")) output)
    (setq output (shell-command-to-string (concat "rbt post -r" review-id)))
    (if (string-match "http://.+" output)
        (browse-url (substring output
                               (match-beginning 0)
                               (match-end 0)))
      (message output))))

(defun chenxuesong-review-code-open (review-id)
  "Open the review board with review id."
  (interactive "sWhich review post you want read? ")
  (browse-url (concat "http://reviewboard.testbird.io/r/"
                      review-id)))

(defun chenxuesong-review-code-diff (review-id)
  "Open the review board with review id."
  (interactive "sWhich review post you want view diff? ")
  (browse-url (concat "http://reviewboard.testbird.io/r/"
                      review-id "/diff")))

(defun chenxuesong-qiniu-upload-img (command)
  (let ((command-str (format "~/Work/dev-tools/qiniu-devtools/qrsync %s"
                             command)))
    (shell-command-to-string command-str)))

(defun chenxuesong-qiniu-achieve-image ()
  (shell-command-to-string "cp -rf ~/Work/blog/images/* ~/Work/blog/images-achieve")
  (shell-command-to-string "rm -f ~/Work/blog/images/*"))

(defun chenxuesong-hexo-generate (args)
  (interactive "P")
  (let ((default-directory chenxueosng-blog-dir))
    (shell-command-to-string "hexo generate")
    (message "hexo generate complete.")))

(defun chenxuesong-hexo-deploy (args)
  (interactive "P")
  (let ((default-directory chenxueosng-blog-dir))
    (chenxuesong-qiniu-upload-img (concat chenxueosng-blog-dir "qiniu.json"))
    (shell-command-to-string "hexo deploy")
    (chenxuesong-qiniu-achieve-image)
    (message "hexo deploy complete.")))

(defun chenxuesong-insert-qiniu-link (imagename)
  (interactive "sImage name: ")
  (insert (concat (format "[[%s%s]]" "http://7xia6k.com1.z0.glb.clouddn.com/"
                          imagename))))
