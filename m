Return-Path: <SRS0=ol6i=4L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994AEC35671
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABFD20836
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgBWRNI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:13:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:15034 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWRNI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Feb 2020 12:13:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 09:13:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,476,1574150400"; 
   d="scan'208";a="229648454"
Received: from ajbergin-mobl.ger.corp.intel.com (HELO localhost) ([10.252.23.203])
  by fmsmga007.fm.intel.com with ESMTP; 23 Feb 2020 09:13:05 -0800
Date:   Sun, 23 Feb 2020 19:13:03 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200223171201.GD5074@linux.intel.com>
References: <20200218104243.GA13967@wind.enjellic.com>
 <8269DEFA-960C-47D0-A1E5-14C427F3CD23@amacapital.net>
 <20200222031607.GA29858@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222031607.GA29858@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 21, 2020 at 09:16:08PM -0600, Dr. Greg wrote:
> Dispassionate observers would note that you make the case for locked
> launch control registers.... :-)
> 
> At an SGX engineering meeting in Israel last summer, we made the case
> for the fact that locked vs. unlocked platforms should be a BIOS
> configurable option.  With an additional option that specifying locked
> also allows specification of what the identity modulus signature
> should be.  That would seem to be the best of all worlds, we will see
> what happens.
> 
> One of the pushbacks we received, is that SGX is supposed to be immune
> from firmware manipulation, which our suggested approach would open
> the door for, which we noted was irrelevant given the trajectory that
> the Linux kernel driver is on, ie. no cryptographic controls over code
> origin and provenance.
> 
> Just to provide a frame of reference, our interest in SGX is with
> respect to its guarantee of integrity of execution, for the purposes
> of verifying that the kernel could not have executed code that was
> outside a desired behavioral definition for the platform.

I'm not too opionated with this. The way things are is the consensus
what is the least common denominator of things that can be accepted by
the majority involved with the kernel.

What I'm deeply opionated is that locked configuration cannot be a part
of the current patch set. I'm neither going to proactively push such
support when the code is in the upstream. However, I'm always ready to
review any code changes and look into arguments (usually contained in
the cover letter) in a neutral fashion, no matter what the code change
is.

/Jarkko
