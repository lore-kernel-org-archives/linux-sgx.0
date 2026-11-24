Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529145;
	b=GejGAUDCuKqT3RV+7Vzjpg6D/qAIYKgNNRYwt26lRAWBGfpxeo8+pHaymI2Sv65r6Yoi
	 IkH9IYuebGOdSay+Euz9lLJknAnXhnfgLj8moau/aW14Sh2KBF52HCLPR2NU3pFVIP8pQ
	 Ui65wFhcv1vmmcftas7oWhUHKf49pzlnB9xCh1LC1I/rMU6leLyv4lcqt1Hir2+NYwN17
	 5+XxxFOqDoLkBMGrNYLsDAkfyvU+Mv7uxFFRPqN1BJXtyEhebnMrnfV/Qr+zdUg3z/WGo
	 B6y5Hh0euevqpyYtRqAhZbAH9BLIm/YsMC8ialGWgIJ5VWPOQcHr7J/n+1Um7K7s2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529145;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uksaHS0GlZddATsY6wbLfDqHqk97x/nZ+jaBRDCZQ/A=;
	b=WBk4vIZNDkzviWG9O6mV6ZpIYgiPb55jyb8JJhDRA+SBet/Kkqyoi0qpIh+pADZEU9ZL
	 TqSibmTmMddf9gvBp4Pi85CNFQsmDy9ywa7zO2PoXmOsS3TeH6/xbPUvIwgc8eN+RD0JD
	 cTkMUPlZLaKbZNDqAwqB0eSdZoJeIvfaX/3NVGOd96FbTVS/Fw4hEwyB7vSgg+W0jR5XW
	 hGkYYckDpgRlJeeBk2Pk6ZjOb4Z1D6bD/NHwudxx6poYBpi5r2mRGpn9Zffk+BNOAs1Jn
	 JMysBZeqiKES8iRSNXU/+limT4zEpKHCATtn7IuB06npsR71mqiIjy9+cN7ftvpWkiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuHD+6BR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7609606A6BD;
	Tue, 24 Nov 2026 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuHD+6BR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0A61F000F2;
	Tue, 24 Nov 2026 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529145;
	bh=uksaHS0GlZddATsY6wbLfDqHqk97x/nZ+jaBRDCZQ/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AuHD+6BR0p+tzbJtwXkbRnF/T5QMNcp4N21BAkRcm3sjw3jGE7tbUCGfDCp9F6q+q
	 DpUIZIWggVslEfQ1cEu3f5K7elBUsfF3scopZOFCPKD/ut84prhokoV/34yZgTHJXN
	 BM4qzuyr9olsnCnpws/QmSwbRaUSvPAvxMmL+uEhMg8B/DgAuwecYKaCR1kBd9a+/8
	 GVKPYclBN2skOxSIty5M8WZPwUJIcu9wl9PWbClnNeyrJlMLjSnTMxNguIhua/B14S
	 aq5WJv10Xdy7Gly+fuV9rRM9oAUHM5y7yMmoalbaYh7GI3SF5CLtkU2KZFzeVUbRJ/
	 jBBlTREL4w7aA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:52 +0000
Subject: [PATCH v2 09/13] soc: qcom: rmtfs_mem: convert mmap hook to
 mmap_prepare
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-9-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org, Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2093; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zPmexgLBdITMLlr8Oq90Rfb+CcnKJfQXvrGy7I+reFc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4rvi3F99JyTz8dZn33x0kNt90x/m3p3xrq5rFnJq
 OreEsTbUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgImYX2FkuNvVdkr+VrjUgjkv
 4o6HiKdUP87Z+tX02vs1EXw799/lusHwi8lxQYCDaXWi6S4G3i8fejZUN36St96R15S0a4L2DDY
 fPgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
PFN remap mmap action to map the region.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/soc/qcom/rmtfs_mem.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/soc/qcom/rmtfs_mem.c b/drivers/soc/qcom/rmtfs_mem.c
index 342c0845134e..5e2ac75f41d5 100644
--- a/drivers/soc/qcom/rmtfs_mem.c
+++ b/drivers/soc/qcom/rmtfs_mem.c
@@ -129,24 +129,22 @@ static const struct class rmtfs_class = {
 	.name           = "rmtfs",
 };
 
-static int qcom_rmtfs_mem_mmap(struct file *filep, struct vm_area_struct *vma)
+static int qcom_rmtfs_mem_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct qcom_rmtfs_mem *rmtfs_mem = filep->private_data;
+	struct qcom_rmtfs_mem *rmtfs_mem = desc->file->private_data;
 
-	if (vma->vm_end - vma->vm_start > rmtfs_mem->size) {
+	if (vma_desc_size(desc) > rmtfs_mem->size) {
 		dev_dbg(&rmtfs_mem->dev,
 			"vm_end[%lu] - vm_start[%lu] [%lu] > mem->size[%pa]\n",
-			vma->vm_end, vma->vm_start,
-			(vma->vm_end - vma->vm_start), &rmtfs_mem->size);
+			desc->end, desc->start, vma_desc_size(desc),
+			&rmtfs_mem->size);
 		return -EINVAL;
 	}
 
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	return remap_pfn_range(vma,
-			       vma->vm_start,
-			       rmtfs_mem->addr >> PAGE_SHIFT,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot);
+	desc->page_prot = pgprot_writecombine(desc->page_prot);
+	mmap_action_remap_full(desc, rmtfs_mem->addr >> PAGE_SHIFT);
+
+	return 0;
 }
 
 static const struct file_operations qcom_rmtfs_mem_fops = {
@@ -156,7 +154,7 @@ static const struct file_operations qcom_rmtfs_mem_fops = {
 	.write = qcom_rmtfs_mem_write,
 	.release = qcom_rmtfs_mem_release,
 	.llseek = default_llseek,
-	.mmap = qcom_rmtfs_mem_mmap,
+	.mmap_prepare = qcom_rmtfs_mem_mmap_prepare,
 };
 
 static void qcom_rmtfs_mem_release_device(struct device *dev)

-- 
2.56.1

