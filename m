Return-Path: <SRS0=/ylb=5S=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317E8C43331
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Apr 2020 19:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 105F920719
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Apr 2020 19:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgDBTth (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Apr 2020 15:49:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:56926 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBTth (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Apr 2020 15:49:37 -0400
IronPort-SDR: wYv2GV+ytKdtboTKkrIuruzM7eF3ilNl915vhhJuyJlcEaDBd3MFQf68Cr59bWDAuAQ7jJm1Jv
 nzdreDCJMNpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 12:49:37 -0700
IronPort-SDR: t3qODGjDNOdJ9mk3MpJFK53Qoo9cFmIkM+wvbYySxuYvdMoTiqYqYyz5xG2JKni+adxtnk9CWL
 jzNNWMZgUyXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="249941363"
Received: from hbriegel-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.101])
  by orsmga003.jf.intel.com with ESMTP; 02 Apr 2020 12:49:33 -0700
Date:   Thu, 2 Apr 2020 22:49:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 0/5] x86/sgx: Make vDSO callable from C
Message-ID: <20200402194913.GE10314@linux.intel.com>
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
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
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

Yeah, lets bring a background :-)

Last week basically rewrote the self-test. It now directly loads ELF and
dynamically signs that. Thus, the codebase has been kind of moving
target for a while. I'm absolutely for these changes as soon as the
form fits to the existing codebase.

/Jarkko
