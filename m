Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529033;
	b=bAnnjPAiQaUwu3mk+pCiuJdInPQbji6IhYVWsZXgVUFFY2iuWvxYclE0p6/CijZMrlnQ
	 99T2zO56j7tL4qGuxaq5MdHZG7f0id5kEa/VSBeqM98WgJYshPB8f6dNZ7NrhjPbhx3QV
	 0OSPurW9cqWRdf7qAgqdH6tNleke+IpykPkLNc2KfL9PjxM8+ePjSybil62AiGYPwHr2J
	 23VSpcdPmb7RMgQQQEGVZKiNFl2R6BsZHCu9l/rfDedPfEBEkxGPivp08VfYx4XNsMvrU
	 68u8BpM5lDCitNtL91zHzvfgFKc5Z4B/nHmbUWov1vKpp14JeecrYNQ+rgyIBdouQ4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529033;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=vJUBuFI/X4ybR5TQJo0mpuZGpnhQ+Y28O/2YwIAeUl0=;
	b=Bd4i7h8xyJPLtnBr9OFYsicaUBfo6pL+YPwngkIOFzeZ90ts5JJN9xV4Bflb3Gs2gLQs
	 U66k6t9SWdvE8lurDrj+ltnd+x+nFW2TuocDwagloM1KKGEqbFe2fhum7g47zNJ+xTp8G
	 d9IRBIqDQ094H0PKV6TjvkHved9u6i/Cvn9PKxf06BPMChWdr0Tjx1xemz5sJVQDSSEEr
	 l0dLnO3fORNd2kDg28wQQvwkpv6Zgt/toywiN0Cc9jdWidgRAKAtrwnUqMfeVQnyzakYe
	 ph/VBMtsfjoXmYQrFfrDolGSsmKkY+/6SGfKwhmqbJvqXBMYJDMUYi04wcrnSj6155A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iHtmG7Cj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6837606A6A9;
	Tue, 24 Nov 2026 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iHtmG7Cj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388EC1F00AE3;
	Tue, 24 Nov 2026 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529033;
	bh=vJUBuFI/X4ybR5TQJo0mpuZGpnhQ+Y28O/2YwIAeUl0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iHtmG7CjTvXPz3lA7PVVVfcohJ6emKtmjQ2NVdO2YLbIRwOCJfD95zg5jaPopSYaS
	 gj5YZqmFSdMCB9FUDQv5kkAhrEJtfG0JXoItpXFghN79meSem8VIAhQgIUFZSzsgAY
	 r4LSrjk7SnXCqTh4BUkrSrsjPXB067ziolwbz+SPR2Ltp0YGJdQcNB/fTa+3srse0H
	 /GlPyBuULOvYPhH5W1j1efHQ11GpECImbgYnAOTpdtXBpeseeeo4Fqv9cOfTrOTpvy
	 kwrbQFsHkQGnl4n4jy0umpUo8SNKV+PrXpeTfoo5qbg7WgAkB1/06qMvPYru+IuxNi
	 f+p2tfqpbV87w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:45 +0000
Subject: [PATCH v2 02/13] KVM: PPC: Book3S: convert spapr TCE mmap hook to
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-2-0b0d99d655f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1158; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gtiaF6eQ5l4kQG69nvAkqE3NZUUEizPFbGQry23tGvI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4oFbmu5VXls3dYr8f7eMuEO344nPNsfMWXNVf7Dq
 qZ7i657dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiU0IYGTbVO6rNXJEyv+mV
 +9vcNeFPj7t/YJz3RnHNZ8l9hdoHV+1h+O8ze3Ji1SVFpXAe612GQm+U5O/yPeIyeLxitpextfz
 t+xwA
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
2.56.1

