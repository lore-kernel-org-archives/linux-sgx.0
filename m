Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFF0C2BA1A
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 16:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9FC720730
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 16:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgDGQwM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:52:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:39067 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgDGQwM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Apr 2020 12:52:12 -0400
IronPort-SDR: ImoGDKbBoMxaD9M/Ox7mT9cWPTKqJMJBUnEfjTLpfvtp9XTQGH8TjnO7rLbyM/0rFUHWo1/s6T
 7XZrVmAB8BGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 09:52:11 -0700
IronPort-SDR: iwLs5pF2hMX7hvuijwvjlr02eK619okKhLNVly2rnep4gVV8mTtcz2l6Lf+t0zO1LmRtCcHw9t
 MJZ+PcdagXgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,355,1580803200"; 
   d="scan'208";a="275160174"
Received: from krausest-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.49])
  by fmsmga004.fm.intel.com with ESMTP; 07 Apr 2020 09:52:08 -0700
Date:   Tue, 7 Apr 2020 19:52:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200407165208.GA14223@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <4768f3fd-74fa-3581-5cda-8c09b4ddc3f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4768f3fd-74fa-3581-5cda-8c09b4ddc3f2@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 07, 2020 at 11:48:10AM +0300, Topi Miettinen wrote:
> On 7.4.2020 0.24, Jarkko Sakkinen wrote:
> > In my opinion udev defining the whole /dev as noexec has zero technical
> > merits. It is same as they would say that "we don't trust our own
> > database". There are no real security benefits as long as dev nodes are
> > configured correctly.
> 
> The threat is not that the device nodes would have execute permissions, but
> that a malicious entity with write access to /dev would create a new
> executable and run it, or rather, trick another (perhaps more privileged or
> more vulnerable) entity to do so. The malicious entity does not need any
> capabilities and it can be constrained by any number of typical seccomp
> filters which just don't block such basic system calls as open(), write(),
> [f]chmod() and close(). It simply needs to have UID 0 (possibly something
> else, like suitable GID could also be sufficient for some subdirectories)
> and write access to /dev (or its subdirectories) in its mount namespace.
> 
> My philosophy is that "trust" means confidence that an action will not be
> done even when there's no control over it. "Control" means that it's
> possible to make active decision on whether the action can or cannot be
> allowed to be done. Trust in security mindset is a weak thing, control is
> stronger, but the strongest case is when you don't need trust nor control:
> the action simply can't ever happen because it's impossible or always
> forbidden. This idea is shown in such famous principles as "least
> privilege", "need to know" or compartmentalization. If the additional
> privilege of exec is not needed, it should not exist.
> 
> -Topi

I get the threat scenario, thanks.

The problem (as Jethro correctly pointed out) with noexec /dev is
somewhat broad.

Thank you anyway for taking time describing the threat scenario.

/Jarkko
