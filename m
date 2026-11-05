Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912774;
	b=T21o7ua+4INLvGQY9hBQbEWZUBQcUNAIqaody44bsdHWiB5Qs4iUeIEN5TfMKvdOJWRR
	 nYnc93VhZpts8zqsdUuIrILdMsBvPjCMs6xjM3eaqx49gFdRx9r6LqeP41skhds3l3G/i
	 Irppd32B7UDv+lzNhVKVtscUGwo5qKSTQ8aULDpaTWLbI5feM8Q0pZxZr2YUMjhy/k3RL
	 Sulr9hpusmX9eZ3oI2e6jgdQGxitHE+frBzqtMr8SCj3xVNsCiFRqbrjDB6U4S/vKFKHY
	 rXNqDk/L5FIR8rVcvOw95L8eUcUvYzqnIyd60HpZ1yqdZHcD2Z0qhJcqfZSbwfPbmOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912774;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=rQ5eRcL8i4WiE6GtABNg6lA1lIZIpMhDQQ82RZBg9WY=;
	b=iMJiDttZDjd7BYUjF6abzbTmcOgwhnLp4G/1Fe74EQ5QT0OQo4V621eTzsE8G/dvrXrq
	 ZLh9/dJjO2XF1vrcYlifR9BvXcJdPOCSkj7G5d8uN05hG4BcD5wI2i4ccH8nJ2UjBrDBM
	 QSHTF1UyMJ75E2HOmntUcv309ZjjgAcbH6/c6rRNeyTBJbeXRHbb/KDbUgiaWh1Hg/FZ5
	 jyE6x0Zomff8eC9u4aNP2hzJprgZNtD8zlVKbnKnTKSbCZGyadVo/jzTwLTsmGX1xVEhP
	 45S97WQ6IUb/gcuz0DgyMATsjVw+RZWwTrg+J4DTHgXrnQiKIailVCUj27q8eiFiOlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8CYFX4J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3710A606A332;
	Thu,  5 Nov 2026 21:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8CYFX4J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190791F008A1;
	Thu,  5 Nov 2026 21:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912773;
	bh=rQ5eRcL8i4WiE6GtABNg6lA1lIZIpMhDQQ82RZBg9WY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S8CYFX4JsG8LD0hbwcgSQGkkF0ToeoZfZ+W7sYhcVvvvyId0c2kXpF/nDLh5GP73y
	 l7FqfeS0r2inh81Q2FLwfe3R1ub9kpTEp9U4p7m3RAnpnM8hrf7E3MImfStu2/hGgP
	 LnSVVcH69MPY1AsZqhp2mJ3P4GZH0mZ86gqHSeymX92cts+0GqS28OGx/cZF7XHj1k
	 GL6MG2AyfpLshr0MBMZ64Ltlwq9gJBLs0ISnJcnAK79zb/Tnl4XS5J9SjY4vmytNA5
	 ICvmM/z0LTXJeWId5xk8NfZc8pCl5JdEtXH1WbDlcIxV8F3Lr49iZHWLQljjvgkmcx
	 kdk0o/ntqNkiA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:32 +0000
Subject: [PATCH 01/14] xen/privcmd: convert mmap hook to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-1-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1514; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GK8WxTPthKHfR93FzNaT4NLMedimx0+ktYQW4BobhBY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF99VPp6bFPmGrbg90HFf0669ovdC6+z+yPP6qT6/
 43lmrDCjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkyiVGhhddyb5uM/686WNQ
 fPLi1lmb7Xrn/+udbrtjGvdeLJrHfj7D/5yLgT+f8MQUZDw4PNFjcW0v43WvQwzhSqW5cg/9JO3
 rWQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook.

The hook only sets VMA flags and operations. The VMA private data is
already NULL at this point, so we no longer explicitly clear it.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/xen/privcmd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 5e56fbc93447..16f96c05af2d 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1630,14 +1630,13 @@ static const struct vm_operations_struct privcmd_vm_ops = {
 	.fault = privcmd_fault
 };
 
-static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
+static int privcmd_mmap_prepare(struct vm_area_desc *desc)
 {
 	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
 	 * how to recreate these mappings */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTCOPY |
-			 VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &privcmd_vm_ops;
-	vma->vm_private_data = NULL;
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTCOPY_BIT,
+			   VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &privcmd_vm_ops;
 
 	return 0;
 }
@@ -1666,7 +1665,7 @@ const struct file_operations xen_privcmd_fops = {
 	.unlocked_ioctl = privcmd_ioctl,
 	.open = privcmd_open,
 	.release = privcmd_release,
-	.mmap = privcmd_mmap,
+	.mmap_prepare = privcmd_mmap_prepare,
 };
 EXPORT_SYMBOL_GPL(xen_privcmd_fops);
 

-- 
2.56.0

