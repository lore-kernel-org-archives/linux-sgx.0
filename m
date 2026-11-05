Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912884;
	b=ucN+kiwI6FEI90VERG575MGza2QKsOtCUy/lbeIaYTOiXUUrrjWHYUx2mnNQ4qvaC424
	 gQHQQ07RQUZ0VpW4cmf8EQX+Y4tzRCNzZ3zhpZ1OqVjUAHkbjES1WZuEINsv4dEbXC6/X
	 k4qcQhJgBWGVsdPQynSOFJQJAlRuKBPmzNJcFPsxnsUzUESGgpqo0yK7XpQf8hAoChf8K
	 oTk+5M3lnJUz1SxP0TujgByi9Ln8/ekoyQKlBj/rgB2COz/+5ecDnM/xuGmYUTYtytiBw
	 fPfs71cAnbuzkwDiFj4g4Lr3J4TUdTqv9/IzQEJORKmUi9qI/F5TU74okZlLNsNdDsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912884;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=AH46OuGdtEt1nsUri8AEqTjCIJ9jhn5rP+r92fYTTuo=;
	b=T6nmcKmtY8DCJLQXIh4aTk7FI7DTbK6NHK0AD30+a7NHw1msNi62XhiXCVW/EDEUH/hZ
	 BS8+wBUP+gRWaoVpTVqfRzE+TN3TVbunMy7aelv+RiIrbEyCjwivCPrzHLi7l0JV85uD/
	 pua4K8l7AsVBExrpKDntakWJWO0gn3UpkQvEu0GIi6v6W2JmSBlNY3HAtg779Hkpx6nRU
	 aMo+Vot3FTZTm1NzkdisH1aTm4WyFbBKOBQ1wVD+VBzM1VHEHbN5VY+RFsOmB0X8uckqh
	 sV5lgHOLyrGoJsmRM0vq21G/RYqWyKU41ltprO8mQL/l/C87NCM2LDL68foPt5AajtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQXtnC+u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518AA606EE98;
	Thu,  5 Nov 2026 21:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQXtnC+u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DBB1F008AB;
	Thu,  5 Nov 2026 21:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912884;
	bh=AH46OuGdtEt1nsUri8AEqTjCIJ9jhn5rP+r92fYTTuo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gQXtnC+uGV3ca+q7ByIhTFttKWFz/mEPWtGFIHyr1U7eyA5UiL3F5di8hwOyKNKIF
	 owKNBe70mg3Zo5esALsOGrB3Gu4dftp1gp/kDfIf8QLSYdragHGzq3le/t0ApgBOdt
	 W9up1YKjS36n6toNIJ3j5acZKXZ8wWo1sMDx7UIrb0pziMl9w8OPwDPPoOYAZT36u2
	 vi8ESoYJVVURVm/u4/xMe23aJwZSVnqx7/HIEZFlTMpz35L2uOhW7gv4mJl1kf17SO
	 iv7fymeQuygUorjvcrauyoeA1G+MidvGijWcp/sEyevbIArziwLEOE45fNvfWtSV44
	 zrRXpq/nRe5Qg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:41 +0000
Subject: [PATCH 10/14] soc: qcom: rmtfs_mem: convert mmap hook to
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-10-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VZRnIpM2wCvIjSh9P+PGr0d/uBMnYJCKqKQo3RqP51A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF/DcEy9Yf31Kzsm7ZGRmTflc4KO8ympbO+gxpqId
 5e4dnYId5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTGBDuDgFYCJ83owMN3b7GPFPClBsUdpb
 91BjyqODrGFXl9VPszke3LF79vZDiYwMd/fO2SCzWsEy+nRExp61KyZ+Xqt1rPVFwbrq23tKLII
 esgIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
PFN remap mmap action to map the region.

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
2.56.0

