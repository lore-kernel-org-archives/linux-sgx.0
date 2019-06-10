Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D374BC31E43
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 17:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A848B207E0
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 17:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfFJRG3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 13:06:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:8749 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbfFJRG3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 13:06:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 10:06:28 -0700
X-ExtLoop1: 1
Received: from cmargarx-wtg.ger.corp.intel.com (HELO localhost) ([10.249.34.77])
  by orsmga004.jf.intel.com with ESMTP; 10 Jun 2019 10:06:24 -0700
Date:   Mon, 10 Jun 2019 20:06:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Message-ID: <20190610170623.GB10114@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-6-sean.j.christopherson@intel.com>
 <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
 <20190606173243.GE23169@linux.intel.com>
 <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 07, 2019 at 12:32:23PM -0700, Andy Lutomirski wrote:
> Sigh.
> 
> It seems silly to add a workaround for a language that has trouble
> calling somewhat-but-not-too-slow syscalls or ioctls.
> 
> How about fixing this in Go directly?  Either convince the golang
> people to add a way to allocate a real thread for a particular region
> of code or have the Go SGX folks write a bit of C code to do  a whole
> bunch of ioctls and have Go call *that*.  Then the mess stays in Go
> where it belongs.

A worker thread would be only appropriate if the existing SGX code was
already in the mainline because then it would break the user space.

Doing it either way right now does not break anything so there is no
case for having it.

/Jarkko
