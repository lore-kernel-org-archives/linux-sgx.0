Return-Path: <SRS0=o5ed=5U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88423C2BA16
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 09:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E31E20719
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 09:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgDDJWz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 4 Apr 2020 05:22:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:40562 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgDDJWy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 4 Apr 2020 05:22:54 -0400
IronPort-SDR: sl1RDpFDd06wTffoiMdAh21rhw/1nxQeg7HcRSMayo6BQFg0dFo6N2YPgZSN8GafUvIc5GM8Y8
 sKeThFdWNTZg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2020 02:22:54 -0700
IronPort-SDR: BydDtS9hqHIzxxTB+JHKopNLxaVzpQikRxc7j8npoX5EnbJTAblerfIw+LjrGPzBI9HhSn4F3f
 JVa7hPIGZJnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,343,1580803200"; 
   d="scan'208";a="241332115"
Received: from lbraszkx-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.75])
  by fmsmga007.fm.intel.com with ESMTP; 04 Apr 2020 02:22:52 -0700
Date:   Sat, 4 Apr 2020 12:22:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200404092246.GB306326@linux.intel.com>
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 03, 2020 at 08:54:40PM -0700, Andy Lutomirski wrote:
> 
> 
> > On Apr 3, 2020, at 3:08 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > 
> > ﻿On Fri, Apr 03, 2020 at 08:50:08AM -0700, Casey Schaufler wrote:
> >>> How does smackfs interact with namespaces?
> >> 
> >> Smack attributes are global. Aside from privilege issues, namespaces
> >> ignore and are ignored by Smack.
> > 
> > Okay.
> > 
> > For SGX, I foresee things as:
> > 
> > 1. Existing files are global.
> > 2. If a policy of any kind is ever added it needs to be *per container*.
> >   I'm not sure whether PID or user namespace is the right choice here,
> >   but does not matter right now as the feature is not in the queue.
> > 
> > To summarize:
> > 
> > 1. We have a heterogeneous set of files (i.e. 'enclave' and 'provision'
> >   are not "different sames").
> > 2. The files probably will have heterogeneous visibility requirements.
> > 
> > I think based on these premises own file system would be a more decent
> > choice than populating /dev. Beside, SGX hasn't been a driver for a
> > while.
> > 
> > Andy, what do you think of this?
> 
> Probably okay.  There are two semantic questions you’ll have to address, though:
> 
> - What happens if you mount sgxfs twice?  Do you get two copies that can diverge from each other, or do you get two views of the same thing?
> 
> - Can it be instantiated from outside the root initns?
> 
> It’s certainly conceptually simpler to stick with device nodes. Why exactly is Ubuntu noexecing /dev?

I'm retreating this given that we have reasonable means to drive
exception to the /dev configuration.

Thanks Jethro for helping with this one!

/Jarkko
