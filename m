Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42536C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 22:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DC9A206BF
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 22:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfFTWWV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 18:22:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:36481 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfFTWWV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 18:22:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 15:22:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="168647930"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2019 15:22:15 -0700
Date:   Fri, 21 Jun 2019 01:22:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     James Morris <jmorris@namei.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        william.c.roberts@intel.com
Subject: Re: [RFC PATCH v3 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
Message-ID: <20190620221954.GF20474@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-10-sean.j.christopherson@intel.com>
 <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com>
 <alpine.LRH.2.21.1906200702040.28119@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1906200702040.28119@namei.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 20, 2019 at 07:13:50AM +1000, James Morris wrote:
> On Wed, 19 Jun 2019, Jarkko Sakkinen wrote:
> 
> > Can LSM callbacks ever non-generic when it comes to hardware? This is
> > the very first time I ever see such callbacks being introduced.
> > 
> > I suspect that from maintainers perspective, accepting such changes for
> > Intel hardware, could open a pandoras box.
> 
> If there's a major distro/userbase committing to ship with these hooks 
> enabled via a supported in-tree LSM, the case for inclusion is clear.

I think there is.

> If the hooks could be generalized beyond just SGX, that would be ideal, 
> but it's not clear if that's feasible.

OK, thanks for responding. This was really important to know what to
focus on (and what not).

/Jarkko
