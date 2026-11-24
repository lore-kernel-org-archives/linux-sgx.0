Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529017;
	b=m6TebOSYZ8Y3aCl/vA4BgdDhuDWAfdofnFVThPLvz7DGE3T+Psd16UBKYM22sT2sqN86
	 njUVWqikfDywipUainOadTFGjTTWxbMncIiWm6mNQFwwQMxf5NzPI3cQkYw0pnJ3BHamb
	 tnISsR8eypP9GkoEwpeNLsbA6h8eXKslpnq1Yj7Qisgw423zSiFevB7NK0OdFvTEVORBw
	 ppsyuVJVEP0RvA/vyzTL0mT+lB47mbpUt/UO78McudOlanpCcwzXxAI+phMqVkVdsO3Q4
	 ySfyesJUQvhlI3N2A/utfWjpc3/71unwKnM+l1bflWjQ7emKWRJ1lDOmA6PXlQmzL9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529017;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=QEgT8LA0rRCf6QNXkIxcU8G4AwB3CCCB3Sy/g9Ov95E=;
	b=H2sTMj0SEkvtsaDlQERQlS0Wf9Nsjqve2zB0H5dHRhFmOvdH15T87Kb1g849xEStFlOw
	 NbmBlKiXIWN0xJrojVc6oltgtJHj20U2zkKMhGlRtNx6nuwvvgPLFZdHJBXtGbSTfN81l
	 AoUITs8tbXxvHd4F6jm9sB1AyeSU8ksZL9WsxhJlE4LZJPAYQdbkRMRZpt9C7YeGeGXN0
	 d5nDQuq6saL4MmXJ+vzg2a6dYFSfj+a+TPm5+2y3AzCB9v7edsT1i3Gswo+oTft18Tkrh
	 MQA1r7sssCaDxq427FiUDuYMQcgqtkt9jh9gDoUk2WlFvUYxq1HU0zHRmnuKvFz08JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgnIva9K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0EC606A6B1;
	Tue, 24 Nov 2026 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgnIva9K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC9E1F000D2;
	Tue, 24 Nov 2026 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529017;
	bh=QEgT8LA0rRCf6QNXkIxcU8G4AwB3CCCB3Sy/g9Ov95E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lgnIva9KLMkUPJObpQOKYtz3otyVdfSMFpdn1jQwIpMlk520FFqMXVbw/h5rCk5aM
	 ZcATjbGD+6/HreWcTYCyu4RHpZTCUrX6vOFINRYB7hegedAzZv3N3ozJ5fa11z9eaM
	 gXXQWOhj64Q7pR47HsOyK6FGHG0uHoSfwTM6XiHuVS7myaCNjsnAuuXHUj/wq9U3p2
	 lQW5/BHNg2s211IbQIjkhHQHG7z2O6su3Yfa2ykLBzNZFs2cu9h189uUCdMinPY7Ev
	 uwAcxEkv+7zGOnE/QurKfUrnjuQWC6+1VYW3BugMR6VXffjfIIPgcP/WlsULN+XnOo
	 BLi/c3ZTzPxGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:44 +0000
Subject: [PATCH v2 01/13] xen/privcmd: convert mmap hook to mmap_prepare
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1514; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vbEx7oZObK1/uvpt+gmlwGGN8AqsAvHpQ+6B/bIbWLc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4p9KnSRk7EO3//5aBbT8vkXtm3ydLgmlDTdz4Xh/
 51DR51rO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR/xmMDDNFecLfebbckfi4
 vE7/m/LcK2sOZZ1nm8rxbKGpph2foA/Df18VkyVbq9Zv5zmv/2rbIZaiJdcOXiqa8Xh3xbur6dX
 d2awA
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
index 221b31611343..6d9e1fe03337 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1645,14 +1645,13 @@ static const struct vm_operations_struct privcmd_vm_ops = {
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
@@ -1681,7 +1680,7 @@ const struct file_operations xen_privcmd_fops = {
 	.unlocked_ioctl = privcmd_ioctl,
 	.open = privcmd_open,
 	.release = privcmd_release,
-	.mmap = privcmd_mmap,
+	.mmap_prepare = privcmd_mmap_prepare,
 };
 EXPORT_SYMBOL_GPL(xen_privcmd_fops);
 

-- 
2.56.1

