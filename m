Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37117C2D0A8
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 16:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A44FA20719
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 16:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="bUE37NEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIWQRl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:17:41 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54726 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIWQRl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 12:17:41 -0400
Received: from zn.tnic (p200300ec2f0d130017aaf728a0fb4ec3.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1300:17aa:f728:a0fb:4ec3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D7FC71EC02F2;
        Wed, 23 Sep 2020 18:17:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600877860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9vrgG+z3uy4woKxYpCo5bmuVsjyUBzW3v2CH/Pl0oAc=;
        b=bUE37NEwPM40nczvs2/wga4QZhAksPnXS9MY18KWeQVXJecV+W77oKZ7RfDHgHuAPCqkcp
        hKhbun0mIlGEH0VsecsvQbCsVCPntncGULXHHfysZvfLpmH9CEN332GOT3q9suDiGqNK1u
        U6XXUkhaUuNMVyXzP8PJZZ7JS2fLj4k=
Date:   Wed, 23 Sep 2020 18:17:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
Message-ID: <20200923161733.GP28545@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
 <20200922154424.GL22660@zn.tnic>
 <20200923132037.GA5160@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923132037.GA5160@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 23, 2020 at 04:20:49PM +0300, Jarkko Sakkinen wrote:
> Intel Sofware Guard eXtensions (SGX) allows creation of executable blobs
> called enclaves, which cannot be accessed by default when not executing
> inside the enclave. Enclaves can be entered by only using predefined memory
> addresses, which are defined the enclave is loaded.
			      ^
			      "when" or "before". I think it is before.

> However, enclaves can defined as debug enclaves during the load time. In

"However, enclaves can be defined as debug enclaves at load time."

> debug enclaves data can be read and/or written a memory word at a time by
> using by using ENCLS[EDBGRD] and ENCLS[EDBGWR] leaf instructions.

only one "by using" is enough.

> Add 'access' implementation to vm_ops with the help of these functions.

"Add an ->access virtual MM function for accessing the enclave's memory... "

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
