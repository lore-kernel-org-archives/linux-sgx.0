Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912786;
	b=nnC83jkLPGNgIR4Sy/3qY5w3YOod6b/75YbVWTjOvf9PEcNMOYEinxo4d3BOFUiMWxBV
	 2MHE/TsHKq+B/hHqsLYz4eRgMW/E2eWTsl1Bg7DrDmJOrYVlieGzb/hIpoiGK5CSLAvGd
	 kCGTzvCQTVfjEkaczNIAHfEk6M9/yn88+GUpzsC6tcwK1Xx79JrnRzvfNw/A6/Io/YTz0
	 S33kLN3x8u2qd/8OIKWL32NWkK4ORI7GnXHtBU8SJXdfcOAjKn56lZSlw/VWuCjKXFFIU
	 wJb4Mu4vS0OR1S7NQuuo6pVP2GT0rAgVHA9Q5acIhTCI/sFJ/aJLIMNyu6uWKBkkkfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912786;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=ndCCV29odaVqmbn+iX3MfTT/qeX9oKJWHuVF4KdBH5Y=;
	b=HIULtAgwwTXxSWLJhNp34q4yP8HQ4OxHhjLsU6RkNF/18pknOgnBi8X0QSdqi5Kqlr/A
	 mntTRucTlT0d7YwpqGhl6Zh9VKtJqeiqgSTix+DbtXLpnSfCgjPN3QHIahK0HGCyMc1tu
	 R+8G+7g5d4twa6n28nfPjh3HG0oqFuKHcVySxhj9u0iW0Ol0VcFj5Iqf0+Xgy5wkIKXsl
	 CDwS/PPPbyVhVIqHJgk5HEzxnpJAksRCZRBi6HklQrpgp51jx7mqqxOasIpjmTe8hCQRC
	 vAwcsNzzzioqTrphVM/dEurfBI6TebD4wsz/KfFOtMiCIF/ODC7cck/YnB6Ok5NmHNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bE1mtiJS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EF8606A31B;
	Thu,  5 Nov 2026 21:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bE1mtiJS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7721F008A2;
	Thu,  5 Nov 2026 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912786;
	bh=ndCCV29odaVqmbn+iX3MfTT/qeX9oKJWHuVF4KdBH5Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bE1mtiJSdVH/EQ/is2LWkUZ/C3yxYBYfLOhHqUTt/CwFIy/gYmtLkJHHuxmtn0qas
	 yO9fbotB7tujrxXdc0dnkvxIV/RhktA0O7/IfKUxqgjQUPFOkQ5XnXZtbaWRijR9Vy
	 rvAxbTT+4e6PNwgjL8QIvMIHw/zcPa1VPCvof+TgcikwT7sEhMMTQsb3zg5PapYZUW
	 2Lseo41qjhjCwu9T0ZH9xcwi/0hu1ZabSEnBK24mSHLfxURPoVykJcET2IhZ4Wtq9c
	 Hnu7ks+Oht5PHDx5NhOAkrNMXAA5S32BMROuJexLAy02FIr8+q5JXl7F26smYgLgC3
	 Q7zdGqQgYr71w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:33 +0000
Subject: [PATCH 02/14] KVM: PPC: Book3S: convert spapr TCE mmap hook to
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-2-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1158; i=ljs@kernel.org;
 h=from:subject:message-id; bh=isNjWX1+rq7D/LCFpxyPlaDLPeXkCD+W3Ok7FRCKcJw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF+9xW/CppYO03VXA+4cXPbxVIsu56wVs7KfZZ3ol
 1lwXPt+bkcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAm8pOXkWGz4+UDqey9qzes
 Xb+fSYpFRlBEUvKQQ1qUfs3xhguqITcY/vus+TRh5qs94ifijyrfz1sVcMt/v+Lr5WJTS9on9iz
 /dooNAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only sets the VMA operations.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index c5f3f5b29d89..05f6f2c9a432 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -247,9 +247,9 @@ static const struct vm_operations_struct kvm_spapr_tce_vm_ops = {
 	.fault = kvm_spapr_tce_fault,
 };
 
-static int kvm_spapr_tce_mmap(struct file *file, struct vm_area_struct *vma)
+static int kvm_spapr_tce_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &kvm_spapr_tce_vm_ops;
+	desc->vm_ops = &kvm_spapr_tce_vm_ops;
 	return 0;
 }
 
@@ -282,7 +282,7 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations kvm_spapr_tce_fops = {
-	.mmap           = kvm_spapr_tce_mmap,
+	.mmap_prepare	= kvm_spapr_tce_mmap_prepare,
 	.release	= kvm_spapr_tce_release,
 };
 

-- 
2.56.0

