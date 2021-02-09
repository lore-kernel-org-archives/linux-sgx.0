Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6307C433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Feb 2021 23:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACCB9601FF
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Feb 2021 23:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhBIXeQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhBIWHK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Feb 2021 17:07:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C7464E7C;
        Tue,  9 Feb 2021 21:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612905501;
        bh=khFnsCSMwitiye71tY8194VIzJl1n1ry6D+5a8rWMv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+GPDIq0bIhDOMyDxrD65ZrORZmbDl4kaXaofMMHAncvNxeOSxVQ5e7O0lNhzMsPW
         AiaP9GD3t79wZ+H/iVrSc3NZsXOHEJIfr8nnv4Ot9GWss6ubR/Dzs7ks/67awgOIWw
         rRKcHMTj2ghbqkbWXXO9PV8j0r8CF/EHLdZfR6od7QI2lZYLl+GhxriIGoP+ZjD2Du
         y2iuwu711Ge3D2/ycLvvIfw7rAIE/9N8mX40BcIDSWu8KiM8pThuiuJNts2jgcj9kE
         fhppqusaW1JYpouIVyubNxsUAyUe5lW0j3ENfUriwNGoBoelW7ej2tThaX9/56BWhD
         3psRyn3OULR3g==
Date:   Tue, 9 Feb 2021 23:18:10 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YCL8ErAGKNSnX2Up@kernel.org>
References: <cover.1612777752.git.kai.huang@intel.com>
 <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 08, 2021 at 11:54:09PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw" EPC
> without an associated enclave.  The intended and only known use case for
> raw EPC allocation is to expose EPC to a KVM guest, hence the 'vepc'
> moniker, virt.{c,h} files and X86_SGX_KVM Kconfig.

This commit message does give existential background for having vEPC.
I.e. everything below this paragraph is "good enough" to make the case
for SGX subsystem controlled vEPC.

However, it does not give any existential background for /dev/sgx_vpec.
Even with differing internals you could just as well make the whole
thing as subfunction of /dev/sgx_enclave. It's perfectly doable. It
does not really matter how much the same internals are used (e.g.
sgx_encl).

Without that clearly documented, it would be unwise to merge this.

/Jarkko
