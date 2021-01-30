Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB057C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Jan 2021 13:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B5864DFA
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Jan 2021 13:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhA3NXf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 Jan 2021 08:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhA3NXf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 30 Jan 2021 08:23:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECC064DFA;
        Sat, 30 Jan 2021 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612012974;
        bh=laBRmlPyVWFNZYqmdw0MJtG8RYOK8bsmseVrbth9No0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MObGDLA2TEO/TLn1FGLgBMxl79hm103GN3r207p+qSfonCbV+dlLTz+dtPrQM5YMf
         6FVkCHnfaH5gSwZh7pWUIvakq3YZx4wKe8rb/LYW2MbdHFGGtRQbZK0Yv0B4tnv3e8
         v2ZhuoFpLqdpJgObBe69tnSFsJvy+Mp5X91NMRFD2E5a/8W0WONHD47vb9E7ioYq0M
         4hJmGmkxyt3x+JJNFG2ca084gi3rCKJxpbNczFk/Mf6bOKlCgzRuP1zKlC+qkl9Py7
         sSfWIB89HbpoTK81FZBI55MhtTbUrhTDkGDAuWjnC73vjWVD+Psj59uw3mE9tTF7/L
         RZRkcfjZyEeig==
Date:   Sat, 30 Jan 2021 15:22:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 02/27] x86/cpufeatures: Make SGX_LC feature bit
 depend on SGX bit
Message-ID: <YBVdqXYphsGWg1Lk@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <bdca25f260a895fcc39b2fb59e1155102a210aa0.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdca25f260a895fcc39b2fb59e1155102a210aa0.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 26, 2021 at 10:30:17PM +1300, Kai Huang wrote:
> Move SGX_LC feature bit to CPUID dependency table as well, along with
> new added SGX1 and SGX2 bit, to make clearing all SGX feature bits
> easier. Also remove clear_sgx_caps() since it is just a wrapper of
> setup_clear_cpu_cap(X86_FEATURE_SGX) now.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

So could this be an improvement to the existing code? If so, then
this should be the first patch. Also, I think that then this can
be merged independently from rest of the patch set.

/Jarkko
