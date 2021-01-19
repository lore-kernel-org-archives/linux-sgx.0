Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0236C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Jan 2021 08:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E3523129
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Jan 2021 08:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbhASId2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jan 2021 03:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbhASIdT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Jan 2021 03:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE8C23121;
        Tue, 19 Jan 2021 08:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611045159;
        bh=MdIpKl/2sDndrqaP6QJm9XLJZHJ5u/s8Jr6LXXojubE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Odd0lho8lHhcmkbd/+DnJxN5VMTyKl+83Vgt9q8zjhB6HkeFFTjPwZ+k9v29fJjrM
         UuszFzOiW0zI8YJ2yDQDf3pXEpaS7JdToJUAFPcv3Q1282sT98RJ2ZLZrB6Z3smOQw
         wjbMfjG1A8TqG4EWaurAMrrZRxxZTWf5ET4djT3a646TGRefpXrkOthwfnSh/2ljEk
         DCgLisiCMANMBAVOtO0wAgqWeCmg4T/X1IGwf7gJy86XAP9L2EUxqd0AdVTzX+XcJE
         IeNSD+ccYtv2+ZXWWBTK4bOaw8DPlusjjceS+PW2s7B3gJmApINwNMLMQ8ao+CEXiT
         9WKOWcqa2AjHA==
Date:   Tue, 19 Jan 2021 10:32:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 02/26] x86/sgx: Remove a warn from
 sgx_free_epc_page()
Message-ID: <YAaZIdxQFHA1XdW4@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <85da2c1ce068b77ee9f31f6de9f3a34c36c410eb.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85da2c1ce068b77ee9f31f6de9f3a34c36c410eb.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 18, 2021 at 04:26:50PM +1300, Kai Huang wrote:
> From: "jarkko@kernel.org" <jarkko@kernel.org>
        ~~~~~~~~~~~~~~~~~~~
        Jarkko Sakkinen

> Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning.  This cannot
> happen, as enclave pages are freed only at the time when encl->refcount
> triggers, i.e. when both VFS and the page reclaimer have given up on
> their references.
> 
> Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
                 ~~~~~~~~~~~~~~~~~
                 Jarkko Sakkinen

> Signed-off-by: Kai Huang <kai.huang@intel.com>

Sorry about this. I was reconfiguring my environment (or actually was
moving it to another machine), and forgot to set user.name. I'll send you
in private replacements with a legit name.

/Jarkko
