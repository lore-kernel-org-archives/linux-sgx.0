Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912860;
	b=lwyhyHnq+RTFLNV7We7IW28sO1tzo13z4zfP988/zQvsvkxOklW2MN+7cnQa7j3UiEre
	 HFe1U+ASMnRij8un3rZ9gOayRqeHSYAoaf6RhCaWqX7bEUKANS7l3DqLl+Ei1ai8a2wEL
	 7943bAqt7hjiW7kH1u0PpwEuP8KtQ4fph8NhL3DP4wf2BC65wDLiDXvet7Ps3qkP3Pdd+
	 s3Ho1x+YM+4yKhYcG3sUsSSTnfbdZ9k0oAW33PG/s43wk7/pkPL7rOzDe43ajOrjnQ615
	 QlvScbOR72xmW+g6f32jm6pzctCqMv6KjuBMv8HfunY6Ikf/aUbTIaN84NSu1yTRzhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912860;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=8poJEEODdqpnj3NMXG7P61yssgyxm5Fvw3WLCRHvkPM=;
	b=4wysxX8wSBJGU2hElOZLEeIzPhrZfyw5oUYESNuYE8qH2GxRBTE0IgrXGZXQxCzUGWdb
	 RIUONg5E2nYZS3to56bBZm5RPMAg4A66BgXzKU1sNih9t/mZq0lrpkEdsllQzHhbiu0O4
	 NFc95aj1QRWm8LZm6+PEZ2dCpHppvV3osP3+JKD3QxkHAWMFPmvYzxF6JrHc+RuMG2B6Z
	 arQ689xYO+4MzOByD+rDdQ6Qr4Vv7CMDZamhXvxNi4aBduoXXi/UzZYPvei+iJDlVy29e
	 zxcF4/u43l0nqWX7/+yeavFWRdzv13X5plGgKoELfwLHNXo7w1+7sCyhsZcJdor/oow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JJnEdLY/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A992C606D81F;
	Thu,  5 Nov 2026 21:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJnEdLY/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3BE1F008A2;
	Thu,  5 Nov 2026 21:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912859;
	bh=8poJEEODdqpnj3NMXG7P61yssgyxm5Fvw3WLCRHvkPM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JJnEdLY/zYN4DtzCvHaF3aYEDTJDbnUNcVAnof1QRCeGAgIIK28vUSZ89mm0DVgQW
	 OZgvxlyxVwupAuJXa6fkzCza5MJNC5CF4+UERI+9chyH32S4KmfH+oQjkhWmNEnkdd
	 NTmlWt8u9sG20yc7yM1IhHIB4PmnviY+RktBJ2Ws3RZfCWOEYw7MPWhPLvtrNgSrJJ
	 CWHFd6q8LuEoPzf2MHgA9gMWZF6dm1M8eBYIEPRBAUhnXPyYf3T9oHdEZwrT2iaQPm
	 QADKRVvIXSwjbnMPyLbtsx5qrxDCRLncA81Gon5WQXHiJDFej/hta0SbkuIGntrRJ5
	 jkSY/KYBGfMXg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:39 +0000
Subject: [PATCH 08/14] xen: convert xenstore interface mmap hooks to
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-8-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2905; i=ljs@kernel.org;
 h=from:subject:message-id; bh=uh2Od35/LsvovUiSJhdcBoUQz0og1zoAftz4JcEDodw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF+TGLFqhuIqraPTpP99SytgzPSUeCxyfgWbx3LzR
 b22OlPtOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRc4EMf6WepYU9X7CEe6LH
 mj+/A6Q+9k5zOmhSeGibH4fHZZXNfb2MDIdflcc7aDTorpSZ8Pb8zNq5Hef3JWZNCZGbx8VxZPM
 tdW4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook for the
xenfs xsd_kva file and the xenbus_backend device, both of which remap the
xenstore interface page.

Use the PFN remap mmap action to do so, retaining the -EAGAIN error on
failure via the action error override.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/xen/xenbus/xenbus_dev_backend.c | 14 ++++++--------
 drivers/xen/xenfs/xenstored.c           | 14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_dev_backend.c b/drivers/xen/xenbus/xenbus_dev_backend.c
index edba5fecde4d..3e4cb267f411 100644
--- a/drivers/xen/xenbus/xenbus_dev_backend.c
+++ b/drivers/xen/xenbus/xenbus_dev_backend.c
@@ -89,27 +89,25 @@ static long xenbus_backend_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int xenbus_backend_mmap(struct file *file, struct vm_area_struct *vma)
+static int xenbus_backend_mmap_prepare(struct vm_area_desc *desc)
 {
-	size_t size = vma->vm_end - vma->vm_start;
+	size_t size = vma_desc_size(desc);
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if ((size > PAGE_SIZE) || (vma->vm_pgoff != 0))
+	if ((size > PAGE_SIZE) || (desc->pgoff != 0))
 		return -EINVAL;
 
-	if (remap_pfn_range(vma, vma->vm_start,
-			    virt_to_pfn(xen_store_interface),
-			    size, vma->vm_page_prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc, virt_to_pfn(xen_store_interface));
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
 
 static const struct file_operations xenbus_backend_fops = {
 	.open = xenbus_backend_open,
-	.mmap = xenbus_backend_mmap,
+	.mmap_prepare = xenbus_backend_mmap_prepare,
 	.unlocked_ioctl = xenbus_backend_ioctl,
 };
 
diff --git a/drivers/xen/xenfs/xenstored.c b/drivers/xen/xenfs/xenstored.c
index f59235f9f8a2..0cf57c286adb 100644
--- a/drivers/xen/xenfs/xenstored.c
+++ b/drivers/xen/xenfs/xenstored.c
@@ -31,24 +31,22 @@ static int xsd_kva_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int xsd_kva_mmap(struct file *file, struct vm_area_struct *vma)
+static int xsd_kva_mmap_prepare(struct vm_area_desc *desc)
 {
-	size_t size = vma->vm_end - vma->vm_start;
+	size_t size = vma_desc_size(desc);
 
-	if ((size > PAGE_SIZE) || (vma->vm_pgoff != 0))
+	if ((size > PAGE_SIZE) || (desc->pgoff != 0))
 		return -EINVAL;
 
-	if (remap_pfn_range(vma, vma->vm_start,
-			    virt_to_pfn(xen_store_interface),
-			    size, vma->vm_page_prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc, virt_to_pfn(xen_store_interface));
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
 
 const struct file_operations xsd_kva_file_ops = {
 	.open = xsd_kva_open,
-	.mmap = xsd_kva_mmap,
+	.mmap_prepare = xsd_kva_mmap_prepare,
 	.read = xsd_read,
 	.release = xsd_release,
 };

-- 
2.56.0

