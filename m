Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912798;
	b=RFcGb9eUWAiugnMqdW6SZRWcDmM+OHoZzUQIVYJBI9n+qNnG8nClDgEb5pkz8QmGuXNL
	 76AHznwdFVx2Y+SQfO+exjAXip5hJp3ewRTr7ZZM3V8fPMxPyLmQrhXq3fJBoE8f8kQGa
	 86pvPzzIIJJVbrSR4jHUwmLb0cmEo64SKWdsWbDYwj5/V1J+HaRgezwHEqSeyAN9gALGo
	 QMH8cAokrssqj0YR6OAHStjEymUth6JUIQX0d1l5hVVuhJKTmXT8uPpqiLbIoYMnDCBcF
	 GKVo7srVIDgwF5f/O/kLpq9ukztXp5s9VlzA8hpxeK8sRz3yPCqfXRwzLHH5n07H1Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912798;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=wDJov6C3ftgFR9HVA3C77e8dvsBn9mUiFAP4oxc5gso=;
	b=AP/5ZPHF7oQKj6gfmTVDqdXm6Ak79K1gGBsApTsFZvW3Kbr8+EPwyOAlM7vTHOQ/6V8l
	 0LBbpaK6WsVSF3ekQrzlWQwTQO82WtYWOtZcAOmxfbuvnHCDuNcyQG9DnsfYgjmh/3gS8
	 GE9NAFmo/dx4XAIAY1Te4YCuqBTSciiIoTb4z/qBcZlRIMcT4zFrpq65GkZgNaeKPbXBT
	 3X66P2gdVCOqVAeek7JUgU9brOK3XSj1y3gmiTQwql77bRVjUzmhM3hWIJHVQMW6VW+X6
	 I+/xRNsGQ/G/vCBFH1HF/AjC/beTK07xi+hbeUYdAS5evKyOOGavlvSWl7vRdZWLkFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F+NMyrHF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A055A606A334;
	Thu,  5 Nov 2026 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F+NMyrHF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891FF1F0089F;
	Thu,  5 Nov 2026 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912798;
	bh=wDJov6C3ftgFR9HVA3C77e8dvsBn9mUiFAP4oxc5gso=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F+NMyrHFBUcpcvdLlYfefS9fChSe5iibGSD2sqAN7qVA/rV6ebmZ5qCXW5xusd1tJ
	 Jq/lz3cUiwOdjnCDcRSzFRFu7nCMmpfyDOOFdQuAyOEPJCLx3Nvs2COSwLWAY5luYJ
	 c2PcdAwxTx9dk3y4715xe2jzU34js3UES+LJWtjJFLPrBAOPwyLzTVL9W0nM8OWnIz
	 JfGm0qQ4ai24kUi0kYZbeEvGkjT0pdY6txBuK83Ejj0f6en7vHE+xr28CVUhMWP+QX
	 Wkx0vicLtz6iHdxQrV8XIL/A4dr/uVz0V7DkZU92pqsOFZbwWhAB53aV0yjoilJZF9
	 E0g82mI+iLpOQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:34 +0000
Subject: [PATCH 03/14] mshv_vtl: convert mmap hooks to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-3-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2014; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JxN0KjNUmrQ4SKv8FW2PS979jApnXc/RSZcYUQZ0Su8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF8tcZL1VfXfq85qV/gLon/N4+6fdOGa+o2dyru2B
 X1qn+Fu3VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ9C5nZPjw5P6i+ClZTf6V
 xw7ZXvyxmPe92OKKh6GXFoi2ysxea3eA4RfzDdW0Q1MsE8q3KzNPSkh3W7fOaWFC8sa6wI0Ncf0
 57/kB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook for both
the mshv_vtl and mshv_vtl_low devices. These only set VMA operations and
flags.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hv/mshv_vtl_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index d8225242c73f..e372d4c0188d 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -832,9 +832,9 @@ static const struct vm_operations_struct mshv_vtl_vm_ops = {
 	.fault = mshv_vtl_fault,
 };
 
-static int mshv_vtl_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mshv_vtl_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &mshv_vtl_vm_ops;
+	desc->vm_ops = &mshv_vtl_vm_ops;
 
 	return 0;
 }
@@ -852,7 +852,7 @@ static const struct file_operations mshv_vtl_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = mshv_vtl_ioctl,
 	.release = mshv_vtl_release,
-	.mmap = mshv_vtl_mmap,
+	.mmap_prepare = mshv_vtl_mmap_prepare,
 };
 
 static void mshv_vtl_synic_mask_vmbus_sint(void *info)
@@ -1283,10 +1283,10 @@ static const struct vm_operations_struct mshv_vtl_low_vm_ops = {
 	.huge_fault = mshv_vtl_low_huge_fault,
 };
 
-static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mshv_vtl_low_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &mshv_vtl_low_vm_ops;
-	vm_flags_set(vma, VM_HUGEPAGE | VM_MIXEDMAP);
+	desc->vm_ops = &mshv_vtl_low_vm_ops;
+	vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT, VMA_MIXEDMAP_BIT);
 
 	return 0;
 }
@@ -1294,7 +1294,7 @@ static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations mshv_vtl_low_file_ops = {
 	.owner		= THIS_MODULE,
 	.open		= mshv_vtl_low_open,
-	.mmap		= mshv_vtl_low_mmap,
+	.mmap_prepare	= mshv_vtl_low_mmap_prepare,
 };
 
 static struct miscdevice mshv_vtl_low = {

-- 
2.56.0

