Return-Path: <SRS0=00MA=DJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368DDC4363D
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 04:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA08208A9
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 04:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJBEZI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgJBEZI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Oct 2020 00:25:08 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F6F20796;
        Fri,  2 Oct 2020 04:25:07 +0000 (UTC)
Date:   Fri, 2 Oct 2020 07:25:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Flatten and clean up struct sgx_enclave_run
Message-ID: <20201002042505.GA34513@linux.intel.com>
References: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
 <20201001165151.GE7474@linux.intel.com>
 <20201001204027.GA18610@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001204027.GA18610@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 02, 2020 at 12:46:11AM +0300, Jarkko Sakkinen wrote:
> > > The documentation, selftest and the kernel source code use the terms "user
> > > handler" and "exit handler" in somewhat inconsistent manner. Start using
> > > "AEX handler" consistently as this is the term that Intel SDM volume D uses
> > > for these events.
> > 
> > No, AEX is specifically for "asynchronus" exits.  In this context, that is
> > limited to the exception path.  The vDSO invokes the user handler for EEXIT,
> > i.e. the synchrous path, which is not an AEX.
> 
> OK, I but this one.
> 
> I got gray hairs because:
> 
> - API called it user handler.
> - Documentation called it exit handler.
> - Selftest called it exit handler.
> 
> I think user_handler is too generic and abstract but I'm happy to hear
> other proposals than 'exit_' to which I will change given your feedback.

OK, so here I use my "too generic" argument pick user handler anyhow
because we don't know what the heck the handler is doing.

'exit_handler' implies that not only it would be called for enclave
exit resulting from an exception, but also for EEXIT path.

/Jarkko
