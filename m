Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912909;
	b=Vjk+ie+VDEPdDVVmNDsk6oXFfuP578dyLr2OtkVaoXW4R4TxWjEXEd21hzrkZ7rBBkGU
	 iTwYBUAQllV4Pul8oiM3grgh95KShhdaphjZ/6NdO7oSwCPV4xYUUh1xHHeCR5BPCFpua
	 u1J2TTa7zmwvOTYgCDBNI52SeYrFyoK+cCMpeIL1rtXgP5boZ9EtuDMiSNhtFM7rYGXPv
	 SivPzNUK/QQ1U8NZarzUVhS0IznGKd+L7G+fvJ+Qn771H28dyWUQ+InhDjf0iW8ASp+Zq
	 uZNCI0VXFciFus8Pu2NKm2okgIZkRrcLWhled9EvBTRxoxC46r7/r82QkiCdgR4pMGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912909;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=rauYFQoBFzCwBAsYPPclHbOZbmTSVBvyT46d2JXEHhc=;
	b=BOOs8pnbxURrjNccmJiHiMPDmetMyZLhHtielKal6kIlO1aTyRGx7vapCUirgHK1ThW9
	 a1UnfGH3npQPcrfSjsd3dHPt43CaZynWsgu/hrXE6qmKrW9K/D5K6RbFzF1PNMF7NDJJX
	 cGqHwuzfJ67q8ZDHDOWpbsKb5gXb1lL2QwLs6qlRQdIt+bANX01XyRshdxgeCUZ6Gr1q6
	 0G2LrDhszGv1/VJSnTNY97UlBVwpodD4394dagmK1wXfL+Sng2LtIjZ2QQp2NanWFsEQt
	 ojt0XBiTkPkxcaijjD0v7PnP908uRiFBO8TNR35HMxc5b4//WLm/T4TTVOJpySXmIJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnKXPWf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48B2606EE9D;
	Thu,  5 Nov 2026 21:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnKXPWf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA46A1F008A1;
	Thu,  5 Nov 2026 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912908;
	bh=rauYFQoBFzCwBAsYPPclHbOZbmTSVBvyT46d2JXEHhc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BnKXPWf+/O22qEiMkaEIK5AaJQQEDaT1ckt5kAk8Dba1GJx7DDQ9aYC3m4YDrEIGm
	 8uQZ6D4EtJ2grfz88MHTsiaTo3NH9vnWalgCLLaXFGMjRWVUklmAAI0MsFx9/+gLLo
	 YFH61ZNKhRR6Fv43NWZZ1RvUEaoATHAHShBGcK7igkT1+d7qa2pXh6tyRcoHCmo4B4
	 GJHLI9LJ1NTDk+gl3j6tt6cw3M3gCPPENxC7J3eiVJghxP1xsN5EbxYHrwvTHymWYS
	 OtjcGqy/Dgj8eYqTO8FncXaIF7WWQN9TMi/urM76XoYWGd0YaiyeJhBjNAMqrCPprm
	 FCGpoxaMo3JlQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:43 +0000
Subject: [PATCH 12/14] misc: bcm-vk: convert mmap hook to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-12-c56aadfbab8a@kernel.org>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
To: Juergen Gross <jgross@suse.com>, 
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
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=ljs@kernel.org;
 h=from:subject:message-id; bh=C9XXK37M9AVAJFlt2rYv5qsDw6jIGdRaJJndLfcUS1A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF8b/+vwX/2MC9qxmsYzmV4FXzC/pc4bfKJ2Q5OY3
 b2PnntCOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRqGaGX8wOptkGu76v+j63
 7fv2GxkrZ3sH69X6n2O5o3H/4/Wjn/UYGTYvDU3rC9p+YLPxLfX24mdT8h4yCywXNmdZ/XhpFuN
 dc3YA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the BAR.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_dev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
index 88ee3a417616..25a2b46ebad9 100644
--- a/drivers/misc/bcm-vk/bcm_vk_dev.c
+++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -1201,9 +1201,9 @@ static long bcm_vk_reset(struct bcm_vk *vk, struct vk_reset __user *arg)
 	return ret;
 }
 
-static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
+static int bcm_vk_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct bcm_vk_ctx *ctx = file->private_data;
+	struct bcm_vk_ctx *ctx = desc->file->private_data;
 	struct bcm_vk *vk = container_of(ctx->miscdev, struct bcm_vk, miscdev);
 	unsigned long pg_size;
 
@@ -1212,16 +1212,16 @@ static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
 
 	pg_size = ((pci_resource_len(vk->pdev, VK_MMAPABLE_BAR) - 1)
 		    >> PAGE_SHIFT) + 1;
-	if (vma->vm_pgoff + vma_pages(vma) > pg_size)
+	if (desc->pgoff + vma_desc_pages(desc) > pg_size)
 		return -EINVAL;
 
-	vma->vm_pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
-			  >> PAGE_SHIFT);
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	desc->pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
+			>> PAGE_SHIFT);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+
+	mmap_action_ioremap_full(desc, desc->pgoff);
 
-	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
+	return 0;
 }
 
 static long bcm_vk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -1262,7 +1262,7 @@ static const struct file_operations bcm_vk_fops = {
 	.write = bcm_vk_write,
 	.poll = bcm_vk_poll,
 	.release = bcm_vk_release,
-	.mmap = bcm_vk_mmap,
+	.mmap_prepare = bcm_vk_mmap_prepare,
 	.unlocked_ioctl = bcm_vk_ioctl,
 };
 

-- 
2.56.0

