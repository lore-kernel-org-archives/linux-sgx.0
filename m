Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529066;
	b=xA3brrKPszj13EiZHiy/KzcF/sE0DsflUg0yvwYSQQTOsV7hxfcame1K07SzDk4zna4B
	 jxStKpL8fin+kBMMiRdmSU/1BbURpP59JXKndyLuqzhFqCLAjgN/o906lwCInouwdEmVN
	 7KZoR3tkBXV7/+TkLp+EN8Rmd92yHHPiuyyE+gJam7DSrsRbGcZHl7MXHGAG/wUNYLA3u
	 1ScsDvT+oro/SZ2Fgm23MgmFBediIwtPaXv0X6e4M/zBIGIAOjhJvCY2gQQor2DDDD6/X
	 4nvvSia//JeaJF14NPhqwGbhYppe255Ix28D54DJ1941sFdXUV9SngSsn775rXqjYtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529066;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uFq9iZYwqLr+1Gr6UEwgMrMnckIbLB1v4c17MlJoT5g=;
	b=3zkoko7XMMp8mFP1ovN6h0Qep81qc/iMB6hdbi9SHWJ/NLpiKRt1iIGjc6maRDX+ZA0L
	 eN7T00Cv8yUYqzoNs0H3oe5MWOVB2oem54trxnF4BiX/PnDakTBy5HxLNmp8pSdA4q+8B
	 T14ma8PALv1jHYb/Ol2jKaUyw/BV2+SK8SYRp4GBC/212iXb8YgISPgV9PM/tbxuzQILF
	 z3tGIuFV98o5rhD7GenfCv2nAlsAdhVVgTyrdmRrzUqQ2F4C+RU2SoCvRIFJQQTRWz7FN
	 +aTo1EbNzhITGMfoiJRBGFgOn0uWkUtSyxMgGvzLgrutFYiYZO6UaK5F1pfKgvIIZtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n4vHYK3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5426D606A32D;
	Tue, 24 Nov 2026 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n4vHYK3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2F11F000D8;
	Tue, 24 Nov 2026 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529065;
	bh=uFq9iZYwqLr+1Gr6UEwgMrMnckIbLB1v4c17MlJoT5g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n4vHYK3heastXfUTv5ny6Odmn4GhFeJjsWDMvoOM4rq57czIeBM1uX2HwsKI+5Of6
	 cWfdqCZutIWrR6o55wcXmgJrwrdNSktSGUMRKVoh80VBsF4YY+clnUFeJleIQ5c0MW
	 0+b9p1+KSNZLSUsm22avuAek7Op1+S83SkVZMJWwhVOyCJY32gIwdaPgwZ+ALwflXa
	 gqUlui6d+xapAgBLj1odarv5GFRZCzZgdga7a5+A2vYj1SnTurtnVRV//J72baeZNd
	 hnTATXOXy01iGcgrYea8kx6/WiYu5rZpkGu5B1iSu0OsY2oRoN9yYVGK42FF/VOfnw
	 Vxw0CovUU3hTA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:47 +0000
Subject: [PATCH v2 04/13] x86/sgx: convert vepc mmap hook to mmap_prepare
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-4-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1716; i=ljs@kernel.org;
 h=from:subject:message-id; bh=otXI3L6hiu1+e3GUvlFZNkY4uUSscpdDKkVudqTwPU8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4p/3pO/9eQqxrjic48NLedd6HjU0Ze0iJ3x4YSX9
 xZPYfpv3FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ1OQy/FOan/Ss2I01Z1aq
 Tm3p8tSlu2uX/HXc82DW92nefIvKc48y/BXZvkmrJpdhwW+N/IYbwZ+n+Uc/yGi/WXC21+nEKm1
 9X34A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only checks that the mapping is shared and sets VMA flags, operations and
private data.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/cpu/sgx/virt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a1933ddc6fc..850990519ca5 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -98,17 +98,18 @@ static const struct vm_operations_struct sgx_vepc_vm_ops = {
 	.fault = sgx_vepc_fault,
 };
 
-static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
+static int sgx_vepc_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct sgx_vepc *vepc = file->private_data;
+	struct sgx_vepc *vepc = desc->file->private_data;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!vma_desc_test(desc, VMA_SHARED_BIT))
 		return -EINVAL;
 
-	vma->vm_ops = &sgx_vepc_vm_ops;
+	desc->vm_ops = &sgx_vepc_vm_ops;
 	/* Don't copy VMA in fork() */
-	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY);
-	vma->vm_private_data = vepc;
+	vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT, VMA_DONTDUMP_BIT,
+			   VMA_DONTCOPY_BIT);
+	desc->private_data = vepc;
 
 	return 0;
 }
@@ -315,7 +316,7 @@ static const struct file_operations sgx_vepc_fops = {
 	.unlocked_ioctl	= sgx_vepc_ioctl,
 	.compat_ioctl	= sgx_vepc_ioctl,
 	.release	= sgx_vepc_release,
-	.mmap		= sgx_vepc_mmap,
+	.mmap_prepare	= sgx_vepc_mmap_prepare,
 };
 
 static struct miscdevice sgx_vepc_dev = {

-- 
2.56.1

