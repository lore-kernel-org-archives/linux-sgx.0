Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8B2C282CE
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 15:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E921C20656
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 15:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfDVPBU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 11:01:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:42394 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfDVPBU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 11:01:20 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 08:01:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,382,1549958400"; 
   d="scan'208";a="317977763"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga005.jf.intel.com with ESMTP; 22 Apr 2019 08:01:19 -0700
Date:   Mon, 22 Apr 2019 08:01:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190422150119.GA1236@linux.intel.com>
References: <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
 <20190420160247.GA17291@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190420160247.GA17291@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 20, 2019 at 11:02:47AM -0500, Dr. Greg wrote:
> We understand and support the need for the LSM to trap these events,
> but what does LSM provenance mean if the platform is compromised?
> That is, technically, the target application for SGX technology.

No, it's not.  Protecting the kernel/platform from a malicious entity is
outside the scope of SGX.
