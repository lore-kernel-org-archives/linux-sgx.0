Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9C2C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 12:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71981221FB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 12:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbhATMV7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731545AbhATLzN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 06:55:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1543206EC;
        Wed, 20 Jan 2021 11:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611143672;
        bh=m0hGLxyRjyQuwevEDwatHLzadWCoG9IxWdwPWe0MxlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UBbU52N5xBXC6QajKw7ThYZIIR0ent0bgz1t/zrP7zu/Tx8IfY3S1fUYzvfzLWYgt
         kkg88r4McCbvVitYC4UlNOm2XryiYqViq06+2TL9nxlGTk5wQsPvKXmpYfzdq+x+wk
         v7PpBlzYhKZfxn9I3wadbV0ICVARyKsXhOlsuklgqhXbzG8fMoity2b7TY9c4qcSu3
         Gx4355+7IJ/EIF5B48tZlgwriBUM9TmujDNKhlBH56G/Bzx9LbPNH0b+0H0qqovc01
         hJWSKjN9HEu4TAopknbMCZqyI0IznYofPe0EiKgcQG2RlGw76fgbI082Vy/BQ1wTAt
         a4dFrjBoT9OnA==
Date:   Wed, 20 Jan 2021 13:54:26 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YAgZ8lGaafoTXcYF@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <4597db567351468c360fc810fff5a8232cb96c4c.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4597db567351468c360fc810fff5a8232cb96c4c.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 18, 2021 at 04:26:53PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> EPC without an associated enclave.  The intended and only known use case
> for raw EPC allocation is to expose EPC to a KVM guest, hence the
> virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.

Is /dev/sgx_virt_epc something only usable for KVM, or is there
any thinkable use outside of the KVM context?

/Jarkko
