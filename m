Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912933;
	b=e4UtUnz/Lvsx6tfY/bhDwiC26qhoG8Ksu1psAOJHRsD7sJNF2/wInSxAdkvS4WVTZ2Te
	 NzX02p2wd9QNGziKPyzPmKP86jCq2DCapkm/nrJj0uqoxihIAPCXaJxalMC7+bIDuxUaF
	 JSZx9sJSJoRaMasLkHVr4fPj3Ygah1hO9k8+7NamTMOd3Q+bsyjNbCZ3djsiDxbt/o4PD
	 9ni1sulQjh7vSycSDtwXLeRgii8WnpueObGAq7c/XXRmFZ4SqpFGveS119Oul685Y/m2B
	 C4ePszhSAUDZ8X5QyvviPttiHNA+zB4HPbjBB4eYUWnH0atPBbw0stHEaZhSmh7kABA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912933;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=f5KzmK9Yc1O2UTKJiw6Ig75W/rQrebyZwa5yMpDxZPA=;
	b=pLScJHH3wL0ljpTaS6WcxHFwU+36boWywu9tDluKtQbIFJV4754kLfU/HRFTFiiblvH/
	 MRsr3UrE1F6mWGUZT770JJ4/1irkn4H58EaREgvSCMb5IU0tX71KT9FnZ3f4hhTpS5ymW
	 UrGwtGWikSNxBYHInFrnzMiGd/EKWZilD5H60o/cY5Ul7+0EaK34laur08rLPaHH/GMld
	 bTkmvdpdc6bel9iwjWgkLtRNnmc4xnlSLxkk/O9DUOcTomX60a/RsaW8RakU06/cHrrCr
	 f6IxscE1TTCAKYprQDBukDbV3sneHHIdTndDU0VuDAlKc5HQ00WjExpa639cXN/zQYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n8CRph5N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412B6606D82C;
	Thu,  5 Nov 2026 21:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n8CRph5N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555ED1F008A2;
	Thu,  5 Nov 2026 21:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912933;
	bh=f5KzmK9Yc1O2UTKJiw6Ig75W/rQrebyZwa5yMpDxZPA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n8CRph5N+6GvMpxdTIZcApabmYM00ArLewFL8fQnfylRd81N3dMFr0fH9tM4p+HtO
	 aUidU5CiMimh6FJxpyYqMz3zczVFtpB2Rg8C6Cvpnenu7HefwcLf7SzXaei+nFpCsq
	 g+IIikN+Wpf5xA5Iml3JdYU+nz+jxroAIVKnx8cAky1Mefm7dQRJYZr4fXxy8faV+B
	 gKm7dUWZnjvRP+x3tKmFXknw94zv5xgigYJCPUGpqxlfNq5n3JmZ8HKLtFE8wxCIUp
	 5Rf8140WFsZqvLSCfX0CiwE+wK86zC1db93JvTfAih23Aag2hbuzEZLeh7mzRE98Cl
	 QUXlmqQj/bSaw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:45 +0000
Subject: [PATCH 14/14] vhost-vdpa: convert mmap hook to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-14-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2490; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JMVxOxpfFwzbko1Dkxmi/MhSfdurHV7XcSZNEQmi5LM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF9bav5wk6fYrXOXd6ULZVa0TPfJ+Lg9MZfZ9diee
 +qG2zLOdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiYXcY/qcUxNtcOqidzSK8
 Kjc5+rCJmY7SZFXp7BChe/6HDFawfmP473xkKtfXWhYbrcSmOwwT5rzNXJ5t/Wde6Okj54p0482
 qOAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only validates the request and sets the VMA flags, operations and page
protection.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/vhost/vdpa.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ff7d90719171..993b2d7c8927 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1573,19 +1573,19 @@ static const struct vm_operations_struct vhost_vdpa_vm_ops = {
 	.fault = vhost_vdpa_fault,
 };
 
-static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
+static int vhost_vdpa_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct vhost_vdpa *v = vma->vm_file->private_data;
+	struct vhost_vdpa *v = desc->file->private_data;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vdpa_notification_area notify;
-	unsigned long index = vma->vm_pgoff;
+	unsigned long index = desc->pgoff;
 
-	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+	if (vma_desc_size(desc) != PAGE_SIZE)
 		return -EINVAL;
-	if ((vma->vm_flags & VM_SHARED) == 0)
+	if (!vma_desc_test(desc, VMA_SHARED_BIT))
 		return -EINVAL;
-	if (vma->vm_flags & VM_READ)
+	if (vma_desc_test(desc, VMA_READ_BIT))
 		return -EINVAL;
 	if (!ops->get_vq_notification)
 		return -ENOTSUPP;
@@ -1598,12 +1598,13 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	if (notify.addr & (PAGE_SIZE - 1))
 		return -EINVAL;
-	if (vma->vm_end - vma->vm_start != notify.size)
+	if (vma_desc_size(desc) != notify.size)
 		return -ENOTSUPP;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &vhost_vdpa_vm_ops;
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+			   VMA_DONTDUMP_BIT);
+	desc->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
 }
 #endif /* CONFIG_MMU */
@@ -1615,7 +1616,7 @@ static const struct file_operations vhost_vdpa_fops = {
 	.write_iter	= vhost_vdpa_chr_write_iter,
 	.unlocked_ioctl	= vhost_vdpa_unlocked_ioctl,
 #ifdef CONFIG_MMU
-	.mmap		= vhost_vdpa_mmap,
+	.mmap_prepare	= vhost_vdpa_mmap_prepare,
 #endif /* CONFIG_MMU */
 	.compat_ioctl	= compat_ptr_ioctl,
 };

-- 
2.56.0

