Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912847;
	b=s+scUTYiHux5s5xQviPTfE2NWRLSEBpDxOWCcaJMuOOMNkACz4UNDRiYmMnu/9LpAZ49
	 RTreANoGmYVOnLQoE4Q1CEW0wMl6xVU5+eug3NBLKNm0X2E/traZP4nT9ty1M2iJbOPPP
	 FmwQdNnV4vwT7n/VBi4wi6z4ZnTYLaomloQd7YusavPti15mpCAPCvMgsQPTsnICbq6np
	 G4B9tdu2ckJWiadWZTpxaSm5gQ8ggydYXiVyX4PVcis0aUqJjzdZHlKPDfSYhtRRny7g7
	 sbIdhswN/GEcjRhZRwmhl3p7yTEg7jdLIqq0yiAXXpRVf0qkHNG+1vCbWwAUIar8/lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912847;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=K0Qe+brxG+0dZUrKAAGrAFU8X9IZH0VVnpzTIvw3ERA=;
	b=O4fWr6nouZf+XgJBHp7+dXsoo+vXwXp/M5yuDjSKHI8Re78Aq4l7L00P/M5n+eLDdX+C
	 9eVZxWiQexiBK//0bIUv0C/YNwJqVmRXMrYQ81KNmDh7ocj65YqYl7rm+1lI2zOtjF5FJ
	 4RTMOZNj1k9ursUwj/LLMweSHCF/TfOqJwyLgRgwjUdzGsd5g5jkkGiLkGWgLjVqFxrzz
	 yjvOFT/ZjF37JhKiB7cj1i67sp532G+ny5b9FGSekOY66wbpvn7HtocAUFxYKQrKJ9yHc
	 +4/jmjExKK/RmLzuA4G00NhyImcMZM3ghpvYoWIHQVvqQPWwHanXtsx3lakEY8zAgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EoGQCLGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A89606A328;
	Thu,  5 Nov 2026 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EoGQCLGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8983A1F0089F;
	Thu,  5 Nov 2026 21:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912847;
	bh=K0Qe+brxG+0dZUrKAAGrAFU8X9IZH0VVnpzTIvw3ERA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EoGQCLGYUECuMK3Ryy2JPZD867vm1Nft2NyWWjYZH04COu4EW/n19poNq9sBYoVuM
	 /9L6U4I6ZY4vXlCPISOuIqoBB5h83vy6AzZrs2irL36W/r0sB/qf1ZvlmEqaeHCR98
	 Yd2HoEORahKhAsOB/TOKoJBhF5tSUb+5it9H8lS7Qhw6Evt7ES6t9E6Hi7+ZQqGPV/
	 km0fScYDuEqdFgtcf7u8IrOQsq2bqZdZcBr9xB/YyRxrFVrgKBphzww0dpecuBV/gD
	 cN1u7CBvszdIwDETsVYy/2zHoypyOCESC6YkymFo3ap/d8M1X84ZFUtyFwrTw/eilV
	 jjk9dx2yFMCwQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:38 +0000
Subject: [PATCH 07/14] selinuxfs: convert mmap hooks to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-7-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2606; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7PdtcPjX+tywnOn8AbMVtXCWtyiPBNa3B2xUfxFmHH4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF/TIhScFGkt26v86da3Ox+Yv91Wnrv55exlR5/1b
 3xS+CHGoqOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATWbaV4Z/R5fMFHr++HXFy
 /Ffm97i/eD5f7pGnC1lXqB4L2nOKY1YTw/9ss1+Cbkvu1sn7vT0cwLOC8VqV2dR7TXeLg2ew97/
 Z5cYPAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook for the
policy and status files.

The policy file only sets VMA flags and operations. The status file remaps
a single page, so use the PFN remap mmap action to do so.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 310e19efff1d..e78c65685020 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -236,27 +236,25 @@ static ssize_t sel_read_handle_status(struct file *filp, char __user *buf,
 				       sizeof(struct selinux_kernel_status));
 }
 
-static int sel_mmap_handle_status(struct file *filp,
-				  struct vm_area_struct *vma)
+static int sel_mmap_prepare_handle_status(struct vm_area_desc *desc)
 {
-	struct page    *status = filp->private_data;
-	unsigned long	size = vma->vm_end - vma->vm_start;
+	struct page    *status = desc->file->private_data;
 
 	BUG_ON(!status);
 
 	/* only allows one page from the head */
-	if (vma->vm_pgoff > 0 || size != PAGE_SIZE)
+	if (desc->pgoff > 0 || vma_desc_size(desc) != PAGE_SIZE)
 		return -EIO;
 
-	return remap_pfn_range(vma, vma->vm_start,
-			       page_to_pfn(status),
-			       size, vma->vm_page_prot);
+	mmap_action_remap_full(desc, page_to_pfn(status));
+
+	return 0;
 }
 
 static const struct file_operations sel_handle_status_ops = {
 	.open		= sel_open_handle_status,
 	.read		= sel_read_handle_status,
-	.mmap		= sel_mmap_handle_status,
+	.mmap_prepare	= sel_mmap_prepare_handle_status,
 	.llseek		= generic_file_llseek,
 };
 
@@ -419,10 +417,10 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 	.page_mkwrite = sel_mmap_policy_fault,
 };
 
-static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
+static int sel_mmap_prepare_policy(struct vm_area_desc *desc)
 {
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &sel_mmap_policy_ops;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &sel_mmap_policy_ops;
 
 	return 0;
 }
@@ -430,7 +428,7 @@ static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations sel_policy_ops = {
 	.open		= sel_open_policy,
 	.read		= sel_read_policy,
-	.mmap		= sel_mmap_policy,
+	.mmap_prepare	= sel_mmap_prepare_policy,
 	.release	= sel_release_policy,
 	.llseek		= generic_file_llseek,
 };

-- 
2.56.0

