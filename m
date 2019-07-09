Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7463C606CF
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 01:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F34216C4
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 01:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGIBwy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 21:52:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:22016 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfGIBwy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 21:52:54 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 18:52:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,468,1557212400"; 
   d="scan'208";a="185802901"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga001.fm.intel.com with ESMTP; 08 Jul 2019 18:52:52 -0700
Date:   Mon, 8 Jul 2019 18:52:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Message-ID: <20190709015252.GC24799@linux.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
 <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com>
 <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551DBF7@ORSMSX116.amr.corp.intel.com>
 <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com>
 <20190703094651.GA29601@wind.enjellic.com>
 <012fc47d-4e9d-3398-0d9d-d9298a758c8d@schaufler-ca.com>
 <20190707133023.GA4521@wind.enjellic.com>
 <256013f7-292d-7014-9abb-61755f07eb25@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <256013f7-292d-7014-9abb-61755f07eb25@schaufler-ca.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 05:02:00PM -0700, Casey Schaufler wrote:
> On 7/7/2019 6:30 AM, Dr. Greg wrote:
> > On Wed, Jul 03, 2019 at 08:32:10AM -0700, Casey Schaufler wrote:
> >
> > Good morning, I hope the weekend has been enjoyable for everyone.
> >
> >>>> On 7/2/2019 12:42 AM, Xing, Cedric wrote:
> >>>>> ...
> >>>>> Guess this discussion will never end if we don't get into
> >>>>> code. Guess it'd be more productive to talk over phone then come back
> >>>>> to this thread with a conclusion. Will that be ok with you?
> >>>> I don't think that a phone call is going to help. Talking code
> >>>> issues tends to muddle them in my brain. If you can give me a few
> >>>> days I will propose a rough version of how I think your code should
> >>>> be integrated into the LSM environment. I'm spending more time
> >>>> trying (unsuccessfully :( ) to discribe the issues in English than
> >>>> it will probably take in C.
> >>> While Casey is off writing his rosetta stone,
> >> I'd hardly call it that. More of an effort to round the corners on
> >> the square peg. And Cedric has some ideas on how to approach that.
> > Should we infer from this comment that, of the two competing
> > strategies, Cedric's is the favored architecture?
> 
> With Cedric's latest patches I'd say there's only one
> strategy. There's still some refinement to do, but we're
> getting there.

Dynamic tracking has an unsolvable race condition.  If process A maps a
page W and process B maps the same page X, then the result of W^X checks
depends on the order of mprotect() calls between A and B.

If we're ok saying "don't do that" then I can get behind dynamic tracking
as a whole.  Even if we settle on dynamic tracking, where that tracking
code lives is still an open IMO.
