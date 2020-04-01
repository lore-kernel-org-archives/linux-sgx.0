Return-Path: <SRS0=Q2Hp=5R=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A77C43331
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 14:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2660206F6
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 14:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732749AbgDAOtj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 1 Apr 2020 10:49:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:25474 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732587AbgDAOtj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 1 Apr 2020 10:49:39 -0400
IronPort-SDR: RH4YM5TXuIN3+j2ycC+liMCkaTrn9XL6nSBHynd5PsLpNvZbAqqPOVL71LSDsitmfRxKiislMd
 e1OfsYa6S1fg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 07:49:38 -0700
IronPort-SDR: MbF5LbyxopDnuAyTUv/lepDdMYmXIKwn4xw4/U9nk+VyUYeUaK/cPICPdkpKPo4myeDd9/6u4Z
 82kv4Hhbbd3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,332,1580803200"; 
   d="scan'208";a="422740961"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 01 Apr 2020 07:49:38 -0700
Date:   Wed, 1 Apr 2020 07:49:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 0/5] x86/sgx: Make vDSO callable from C
Message-ID: <20200401144938.GD31660@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330204839.GH1384380@linux.intel.com>
 <CAOASepPxHCh_SfA3krurq5oQaikZ7YpyDqcW9A6RQ_E5OoMn+Q@mail.gmail.com>
 <20200331115822.GD8295@linux.intel.com>
 <CAOASepPgNWHg8RVAU5b6CDE4K6LwhiHHdHUiN57ay6T+xAx7Ow@mail.gmail.com>
 <20200401081756.GA17325@linux.intel.com>
 <CAOASepNRgy7Fo7iU0Y=bpFXpA-WfY--d6LL1rKMZSm79SDK+gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepNRgy7Fo7iU0Y=bpFXpA-WfY--d6LL1rKMZSm79SDK+gw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 01, 2020 at 09:06:38AM -0400, Nathaniel McCallum wrote:
> On Wed, Apr 1, 2020 at 4:18 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Tue, Mar 31, 2020 at 09:40:24AM -0400, Nathaniel McCallum wrote:
> > > On Tue, Mar 31, 2020 at 7:58 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > >
> > > > On Mon, Mar 30, 2020 at 05:42:29PM -0400, Nathaniel McCallum wrote:
> > > > > On Mon, Mar 30, 2020 at 4:48 PM Jarkko Sakkinen
> > > > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > > >
> > > > > > On Mon, Mar 30, 2020 at 11:08:06AM -0700, Sean Christopherson wrote:
> > > > > > > Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> > > > > > > close to being callable from C (with caveats and a cooperative enclave).
> > > > > > > The missing pieces are preserving %rbx and taking @leaf as a standard
> > > > > > > parameter.
> > > > > > >
> > > > > > > v2:
> > > > > > >   - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
> > > > > > >   - Add CFI directive for RBX. [Cedric]
> > > > > >
> > > > > > I'm sorry for throwing stick's constantly but I think having a real
> > > > > > ELF loader is for better.
> > >
> > > This statement seems like you are juxtaposing having
> > > __vdso_sgx_enter_enclave() be potentially C-compatible with having an
> > > ELF-loader. These are not incompabile. __vdso_sgx_enter_enclave() can
> > > be C-callable *and* you can have an ELF loader.
> >
> > I'm not honestly sure what this is about but my comment was about heavy
> > rebasing of the GIT tree as I rewrote the selftest last week.
> 
> Okay. Let's chalk it up to miscommunication then. :)

Ha, I was in the same boat as Nathaniel.  We thought the "having a real
ELF loader comment" was a comment on the patch itself, i.e. that you
disagreed with it in some way because it didn't support an ELF loader,
hence our confusion.

Now I realize you were refering to the rebase needed due to rewriting the
selftest to use an ELF loader.  Crisis aborted :-)
