Return-Path: <SRS0=pIwf=6N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED0AC83000
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 15:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495BD206F0
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 15:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgD2PaG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:30:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:53437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2PaF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Apr 2020 11:30:05 -0400
IronPort-SDR: glru2NjHAqeLb9eMFKK5uSxfskdQU5n//BnA/v5vG/YxRC58ax38nqC75wLbpux/g120Jq5xd+
 gIre5RnCqTCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 08:30:05 -0700
IronPort-SDR: IsOo2m5hKDJWvB8cLxXv2tSJTgbWHqTSHwVmntgbu4ZJeYgSkqhJZFzNg96HRz/pCPc/2/jOMh
 iee/vjZ65KWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="257994210"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 29 Apr 2020 08:30:05 -0700
Date:   Wed, 29 Apr 2020 08:30:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200429153004.GD15992@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426165753.GA11046@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Apr 26, 2020 at 11:57:53AM -0500, Dr. Greg wrote:
> In closing, it is important to note that the proposed SGX driver is
> not available as a module.  This effectively excludes any alternative
> implementations of the driver without replacement of the kernel at
> large.

No it doesn't.  The SGX subsytem won't allocate EPC pages unless userspace
creates an enclave, i.e. preventing unprivileged userspace from accessing
/dev/sgx/enclave will allow loading an alternative out-of-tree SGX module.
Yes, SGX sanitizes the EPC on boot, but that's arguably a good thing for
out-of-tree modules.

And if you want to get crafty and squash in-kernel SGX altogether, boot
with "clearcpuid=<SGX_LC>" and/or "clearcpuid=<SGX>" to disable in-kernel
support entirely.  SGX won't be correctly enumerated in /proc/cpuinfo
relative to the existence of an out-of-tree module, but that seems like a
very minor issue if you're running with a completely different SGX driver.

> It also means that any platform, with SGX hardware support,
> running a kernel with this driver, has the potential for the
> security/privacy issues noted above.

Unless I'm mistaken, /dev/sgx is root-only by default.  There are far
scarier mechanisms available to root for hosing the system.

> If key based policy management is not allowed, then the driver needs
> to be re-architected to have modular support so that alternative
> implementations or the absence of any driver support are at least
> tenable.

As above, using an alternative implementation is teneble, albeit a bit
kludgy.
