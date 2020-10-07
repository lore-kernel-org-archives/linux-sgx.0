Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6143EC4363C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 19:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BDBD207EA
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 19:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgJGT7B (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 15:59:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:48587 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgJGT7B (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 15:59:01 -0400
IronPort-SDR: K8Xq+uJA2BcnmwxC9geAKK1nNVNOttOHXjacSh+BkSBoaGnu+HxNidhHM+CkYsBkYWHeC4rh45
 cAQFmo8VxkNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="151993645"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="151993645"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 11:37:03 -0700
IronPort-SDR: clk1EV+6rJTlCVLZwBArdCPqWpcCzIs4ULri3m+WGBtiN2zW7CGEgFNJ2PZyIpmKBme4VP0aFi
 0Rst6Kfldc2w==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="461446574"
Received: from klitkey1-mobl.fi.intel.com (HELO localhost) ([10.249.33.29])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 11:36:59 -0700
Date:   Wed, 7 Oct 2020 21:36:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: Unable to load large enclave
Message-ID: <20201007183656.GB4850@linux.intel.com>
References: <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
 <20200930114554.GA7612@linux.intel.com>
 <20201005225652.GD15803@linux.intel.com>
 <20201006151328.GA109815@linux.intel.com>
 <20201007154938.GA19072@linux.intel.com>
 <f362318e-2d14-c82d-82a8-35c35842f84c@fortanix.com>
 <20201007172058.GD3885@linux.intel.com>
 <f56d8b2c-36ce-0852-c1d4-5e1b41a491f7@fortanix.com>
 <20201007183457.GA4850@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007183457.GA4850@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 09:35:06PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 07, 2020 at 08:14:48PM +0200, Jethro Beekman wrote:
> > It's this one in do_mmap():
> > 
> > 	/* Too many mappings? */
> > 	if (mm->map_count > sysctl_max_map_count)
> > 		return -ENOMEM;
> > 
> > I've verified that I'm no longer getting the problem when increasing
> > /proc/sys/vm/max_map_count . Why do I need to change this from the
> > default compared to before?
> 
> Yes, you are correct. I came into same conclusion and responded (once
> again) to my own email after running this:
> 
> ➜  ~ (master) ✔ sudo bpftrace -e 'kr:ksys_mmap_pgoff { @[comm] = count(); }' &> log.txt
> ^C
> ➜  ~ (master) ✔ cat log.txt
> Attaching 1 probe...
> 
> 
> @[cat]: 18
> @[git]: 47
> @[zsh]: 49
> @[cargo]: 94
> @[sgx-load-large-]: 65510
> 
> That is the default value for /proc/sys/vm/max_map_count.
> 
> Re-responding just in case because I thought that the bpftrace snippet
> might have some value for you. I don't why I cannot see my email at
> lore.kernel.org.

... looking also forward to run this test and the test suite (have
not tried yet) in the master branch. This all is really useful for
me that you are doing.

/Jarkko
