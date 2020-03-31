Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D46C43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B237320848
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgCaL6j (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:58:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:13567 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730343AbgCaL6j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 07:58:39 -0400
IronPort-SDR: tEdmktS8W6HlewTMHj6A4gCIET67gk4D2DzrymIgHabO1cA8oSV4Dl9yLmKOuxk4amLayHjigJ
 szLJc7l69itw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 04:58:38 -0700
IronPort-SDR: MfZt/JJGH3o4J9rlE3QsdM2qji/8I/xS5Uz6jNoOb1wK9S9caWZhoEX8X1/j8nPvxDVXzzssRW
 sKADHP2rozPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="237678216"
Received: from tking1-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.59.94])
  by orsmga007.jf.intel.com with ESMTP; 31 Mar 2020 04:58:36 -0700
Date:   Tue, 31 Mar 2020 14:58:35 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 0/5] x86/sgx: Make vDSO callable from C
Message-ID: <20200331115822.GD8295@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330204839.GH1384380@linux.intel.com>
 <CAOASepPxHCh_SfA3krurq5oQaikZ7YpyDqcW9A6RQ_E5OoMn+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepPxHCh_SfA3krurq5oQaikZ7YpyDqcW9A6RQ_E5OoMn+Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 05:42:29PM -0400, Nathaniel McCallum wrote:
> On Mon, Mar 30, 2020 at 4:48 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Mon, Mar 30, 2020 at 11:08:06AM -0700, Sean Christopherson wrote:
> > > Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> > > close to being callable from C (with caveats and a cooperative enclave).
> > > The missing pieces are preserving %rbx and taking @leaf as a standard
> > > parameter.
> > >
> > > v2:
> > >   - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
> > >   - Add CFI directive for RBX. [Cedric]
> >
> > I'm sorry for throwing stick's constantly but I think having a real
> > ELF loader is for better.
> 
> Why is it one or the other?

Hmm... Not sure I understand what you want to know.

A raw binary requires a hardcoded way to interpret it. Obviously ELF
is for better.

/Jarkko
