Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206CFECE596
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 19:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4862206C0
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 19:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="NpM8Tp+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfJHTTc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 15:19:32 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35522 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfJHTTc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 15:19:32 -0400
Received: from zn.tnic (p200300EC2F0B51004985F04ADA683F0C.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5100:4985:f04a:da68:3f0c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AB3EF1EC06F3;
        Tue,  8 Oct 2019 21:19:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570562371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CXUWmFNA5mJOZLZURrkTqJUH033VU6Q2eTZE4s/PFuM=;
        b=NpM8Tp+a3MgxgQKjF033zwArkWT3yMe1dh6y1gUqywSYHGFRWNYjSuH9JXq0bCBmTkLVAc
        ygosv8qUEfzwIqBCzSaIi2Wgnucu9/HpbCnzxillmVzy8A4bF6OLjlGJSpy3xDSsxhJilM
        afHuOc4lN7OwJE3fk/J4PS1mwxjPRMo=
Date:   Tue, 8 Oct 2019 21:19:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v22 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191008191924.GP14765@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-13-jarkko.sakkinen@linux.intel.com>
 <20191008175924.GN14765@zn.tnic>
 <20191008181752.GE14020@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191008181752.GE14020@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 08, 2019 at 11:17:52AM -0700, Sean Christopherson wrote:
> There are already a handful of driver changes on our todo list for v23, as
> well as the vDSO and selftest updates.  What if you stop here for now and
> restart when Jarkko sends v23?  In theory that'll happen later this week.

Sure, sounds good.

Thx!

/me goes to the next patchset on TODO list :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
