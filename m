Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0251C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Jan 2021 13:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09E764E0C
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Jan 2021 13:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhA3NMG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 Jan 2021 08:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhA3NMF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 30 Jan 2021 08:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB43D60235;
        Sat, 30 Jan 2021 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612012285;
        bh=m3ZnxRe/kgAbv1hWdDIPtBmiARwysYIMnvEru0zEGhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4i7V5ejZoSndy0b3oQ8q7xpMopzMKh2+7qLS7cjK2mm59cs4l31mtgH3zHGwzQYW
         pyaqRSnn8sssncHPlZ7WexqNE1qvL+OWSO8fiVF3B6V+8oJayMAV04hl9TwnG1WXIU
         jb8catoktNE4k930+iWJspO1+E88SAtqJhQV5qEVK2IO/eul9cKE8yVY69NVhw+UX2
         poRHUy310HtT5iWmzAzGoTftTxrSblN2NqpTK3u36xcPeo12uMMJJLjJHSPPGD1x6o
         HHnAE0zQqQvQx6QqLncbbeqvyQaR5U3+0sItH8gIUnZV7L4l2foRY20kqU8qBmYqpc
         3xJ4yfCnJ7XTg==
Date:   Sat, 30 Jan 2021 15:11:20 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YBVa+HBk6/MbjpOo@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 26, 2021 at 10:30:16PM +1300, Kai Huang wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> features, since adding a new leaf for only two bits would be wasteful.
> As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
> guest, and to do so correctly needs to query hardware and kernel support
> for SGX1 and SGX2.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
 
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
