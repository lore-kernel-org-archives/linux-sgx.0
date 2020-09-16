Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFA0C433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 15:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4125F224DE
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 15:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgIPP7c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 11:59:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:26160 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgIPP7V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Sep 2020 11:59:21 -0400
IronPort-SDR: Nou1s9vYz+cUrR2WHtE+5bmWtavOnXNTzkmYmYyNz9he3RedrKqso6jG4PeERHFuPvdStOqspa
 5URahKjvBt4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="158786308"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="158786308"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 08:57:11 -0700
IronPort-SDR: vO3xT64Rc9Yi4I8JGyJpAXgCwBYFYMUUsxDVJKwSyhAl6loi5G41Lvdam9Hynlg+TSCxVqE2wm
 Wn0Rbc5Rxv5Q==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="451910610"
Received: from scusackx-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.87])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 08:57:04 -0700
Date:   Wed, 16 Sep 2020 18:57:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v37 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200916155702.GA21026@linux.intel.com>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
 <20200915095716.GI3612@linux.intel.com>
 <20200915132725.a2qbdio3jsu7rsqs@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915132725.a2qbdio3jsu7rsqs@treble>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 08:27:25AM -0500, Josh Poimboeuf wrote:
> On Tue, Sep 15, 2020 at 12:57:16PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Sep 14, 2020 at 10:38:26AM -0500, Josh Poimboeuf wrote:
> > > On Mon, Sep 14, 2020 at 10:18:16AM -0500, Josh Poimboeuf wrote:
> > > > Hi Jarko,
> > > > 
> > > > It looks like some of the patches weren't delivered to the lists.
> > > > Patches 0, 1, 8, 9, and 17 seem to be missing.
> > > > 
> > > > Lore agrees with me:
> > > > 
> > > >   https://lore.kernel.org/linux-sgx/20200911124019.42178-1-jarkko.sakkinen@linux.intel.com/
> > > 
> > > And my first email to you bounced, similar to an email I tried sending
> > > to Kristen a few weeks ago.  Something weird going on with Intel mail
> > > servers?
> > 
> > Possible. I don't honestly know what is going on.
> > 
> > At least now all the patches are out:
> > 
> > https://lore.kernel.org/linux-sgx/
> > 
> > Not sure if a resend would make sense for the full patch set but maybe I
> > just do quick iteration and send v38 soon. And just in case use some alt
> > smtp server.
> 
> I see the v37 missing patches now, but they're not threaded with the
> original thread.  v38 has some missing patches as well.

Now, v38 is there as complete but it has a duplicate version (they have
exact same contents). Through the alternative mail server it just took
hours to get them to LKML so I did another git send-email :-(

Anyway, there is no difference between the patch sets marked as v38.

> 
> -- 
> Josh
> 

/Jarkko
