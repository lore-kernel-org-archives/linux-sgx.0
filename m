Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529130;
	b=5T0YJJvqyAC7KNIu8rJnWvu+t0SbWJplGQgUAxpaysufi7gTx6s/4gu60+nxv6a87/e7
	 IZjSavJBN3sJf6947giGx+BiORWNjorMn0rncLHpFRZZh3wloSS4IqItVArL2fvMRLIJE
	 FL4yQv+EsN8zdQgcZPBcVDI7UomiQIOx1m9hHlmKFa5e8jtoIY6cKQVh1S1B28P2IzbKq
	 kN52wWGHcZkVU/hWxmIEqjcnUwRHf+wqHsAEXg1uvAgzqCKUM9nsKAeaJFAUwSq6lt3yU
	 Qr8X+60wZfp1L3x8zZ4YVOPC+P5fKfon541FEQuV4i+KXH4g5786c4fKZogl+y5WDiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529130;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=SrYlGGY0gACro/+moR4ki8LLaruR+DRcq/Omm4chfzc=;
	b=ZUSgMF2J535mKZ00gjve1n/ROUIFNZecKiqZUqX63/JfurVMxpqnNBhLJpQnd6KCLoAy
	 v3+/uvAHO1Udl0XL5TghaKDvXdKDpz/rj3p2b5H7lv2cYNsUIxyj1X/k7wOG6SPtGqaSN
	 pVLVEJGzvBW9FTO6PC9YJ1cVCy1oDa7POgYPAKbG0WYescJJdw61FIeDrA9KT9A+2JA2v
	 9bv8sYJ/zcEyKkXPx1HtttTnBa1QP5NxvtsNQfzBDaW+5ociPLPi6NA3iSaZZqrNPbm52
	 5lyj4h+lrsA8nHpGAjIb0PTZ6VyoSFGmjgy3fkKUZIjnIo3zd6LI/oQYvK8NPDXqQYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDqI3wph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D72606A6BD;
	Tue, 24 Nov 2026 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDqI3wph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83991F000EE;
	Tue, 24 Nov 2026 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529129;
	bh=SrYlGGY0gACro/+moR4ki8LLaruR+DRcq/Omm4chfzc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cDqI3wph5w7mSk7+SA/9MbSHsr7FMUNedC7vWKFhxrOIlpLi/Jg4MsG1xI0bxGAWy
	 qUiRaEAEH9wspwamO2MBPTiaLlH+o8/BVteTJUZpqSzXmShf0FdMFnZW3UEQJcz7qC
	 f0q+icWXYKtjYOrK50ZhDj/QKBpyCbqFkfEyHMExa5AY7OG1tFqiudHtdUMmkTRev9
	 aGc5oo1L+3PAwfFOjRq5w+19u+ENdztRn8Q+pxEcrA7oJco/+Rjiqm6mmh5CB+kEqL
	 sIffKObc49Vrs4vWH7Uf0X1GOMC5zvZdhqnNg0SOOT3TWCwu12uPxmZxl+e1i6P7ig
	 N7AdOF2UuX5WA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:51 +0000
Subject: [PATCH v2 08/13] soc: aspeed: convert LPC and P2A control mmap
 hooks to mmap_prepare
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4097; i=ljs@kernel.org;
 h=from:subject:message-id; bh=s32LdAaaGb1M+/iwl2Ev3ih3n8WWn5YLe6Ixr8jPsP8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4rzb1g8Sfr0brEfn7ZbKupLCrGYKk8Tb2y48VJl3
 jY9zdPzO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR19MY/hnu+fP5693M5Yyr
 ejU5//XJhc6sqJ6o9PpW5fE7dQeKBLMZGc4t57X/s8jJhD/YdFVqu/caTalFBt/OvYpdl9D1e27
 EOQYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook for both
the LPC control and P2A control drivers.

Both remap a range of their reserved memory region, so use the PFN remap
mmap action to do so, retaining the -EAGAIN error on failure via the action
error override.

Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-ctrl.c | 20 +++++++++-----------
 drivers/soc/aspeed/aspeed-p2a-ctrl.c | 22 ++++++++--------------
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-ctrl.c b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
index 5d91ba2038d5..702fb3e85472 100644
--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -47,22 +47,20 @@ static struct aspeed_lpc_ctrl *file_aspeed_lpc_ctrl(struct file *file)
 			miscdev);
 }
 
-static int aspeed_lpc_ctrl_mmap(struct file *file, struct vm_area_struct *vma)
+static int aspeed_lpc_ctrl_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct aspeed_lpc_ctrl *lpc_ctrl = file_aspeed_lpc_ctrl(file);
-	unsigned long vsize = vma->vm_end - vma->vm_start;
-	pgprot_t prot = vma->vm_page_prot;
+	struct aspeed_lpc_ctrl *lpc_ctrl = file_aspeed_lpc_ctrl(desc->file);
 
-	if (vma->vm_pgoff + vma_pages(vma) > lpc_ctrl->mem_size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) >
+	    lpc_ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
-	prot = pgprot_noncached(prot);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-		(lpc_ctrl->mem_base >> PAGE_SHIFT) + vma->vm_pgoff,
-		vsize, prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc,
+		(lpc_ctrl->mem_base >> PAGE_SHIFT) + desc->pgoff);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -216,7 +214,7 @@ static long aspeed_lpc_ctrl_ioctl(struct file *file, unsigned int cmd,
 
 static const struct file_operations aspeed_lpc_ctrl_fops = {
 	.owner		= THIS_MODULE,
-	.mmap		= aspeed_lpc_ctrl_mmap,
+	.mmap_prepare	= aspeed_lpc_ctrl_mmap_prepare,
 	.unlocked_ioctl	= aspeed_lpc_ctrl_ioctl,
 };
 
diff --git a/drivers/soc/aspeed/aspeed-p2a-ctrl.c b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
index efa106d37bd7..7387b0cd8666 100644
--- a/drivers/soc/aspeed/aspeed-p2a-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
@@ -97,29 +97,23 @@ static void aspeed_p2a_disable_bridge(struct aspeed_p2a_ctrl *p2a_ctrl)
 	regmap_update_bits(p2a_ctrl->regmap, SCU180, SCU180_ENP2A, 0);
 }
 
-static int aspeed_p2a_mmap(struct file *file, struct vm_area_struct *vma)
+static int aspeed_p2a_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned long vsize;
-	pgprot_t prot;
-	struct aspeed_p2a_user *priv = file->private_data;
+	struct aspeed_p2a_user *priv = desc->file->private_data;
 	struct aspeed_p2a_ctrl *ctrl = priv->parent;
 
 	if (ctrl->mem_base == 0 && ctrl->mem_size == 0)
 		return -EINVAL;
 
-	vsize = vma->vm_end - vma->vm_start;
-	prot = vma->vm_page_prot;
-
-	if (vma->vm_pgoff + vma_pages(vma) > ctrl->mem_size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) > ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
-	prot = pgprot_noncached(prot);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-		(ctrl->mem_base >> PAGE_SHIFT) + vma->vm_pgoff,
-		vsize, prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc,
+		(ctrl->mem_base >> PAGE_SHIFT) + desc->pgoff);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -308,7 +302,7 @@ static int aspeed_p2a_release(struct inode *inode, struct file *file)
 
 static const struct file_operations aspeed_p2a_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.mmap = aspeed_p2a_mmap,
+	.mmap_prepare = aspeed_p2a_mmap_prepare,
 	.unlocked_ioctl = aspeed_p2a_ioctl,
 	.open = aspeed_p2a_open,
 	.release = aspeed_p2a_release,

-- 
2.56.1

