Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34E2C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8462E20851
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfFDUMd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:12:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:65370 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFDUMc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 16:12:32 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 13:12:32 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 04 Jun 2019 13:12:32 -0700
Date:   Tue, 4 Jun 2019 13:12:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>
Subject: Re: [PATCH v20 15/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190604201232.GA7775@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
 <20190422215831.GL1236@linux.intel.com>
 <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com>
 <20190424002653.GB14422@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424002653.GB14422@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 05:26:53PM -0700, Sean Christopherson wrote:
> On Tue, Apr 23, 2019 at 11:29:24PM +0000, Jethro Beekman wrote:
> > On 2019-04-22 14:58, Sean Christopherson wrote:
> > >Where do we stand on removing the ACPI and platform_driver dependencies?
> > >Can we get rid of them sooner rather than later?
> > 
> > You know my position on this...
> > https://www.spinics.net/lists/linux-sgx/msg00624.html . I don't really have
> > any new arguments.
> > 
> > Considering the amount of planned changes for the driver post-merge, I think
> > it's crucial that the driver part can be swapped out with alternative
> > implementations.
> 
> This gets far outside of my area of expertise as I think this is more of
> a policy question as opposed to a technical question, e.g. do we export
> function simply to allow out-of-tree alternatives.
> 
> > >Now that the core SGX code is approaching stability, I'd like to start
> > >sending RFCs for the EPC virtualization and KVM bits to hash out that side
> > >of things.  The ACPI crud is the last chunk of code that would require
> > >non-trivial changes to the core SGX code for the proposed virtualization
> > >implementation.  I'd strongly prefer to get it out of the way before
> > >sending the KVM RFCs.
> > 
> > What kind of changes? Wouldn't KVM just be another consumer of the same API
> > used by the driver?
> 
> Nope, userspace "only" needs to be able to mmap() arbitrary chunks of EPC.
> Except for EPC management, which is already in built into the kernel, the
> EPC virtualization code has effectively zero overlap with the driver.  Of
> course this is all technically speculative since none of this is upstream...

Jarkko, can you weigh in with your thoughts on the ACPI stuff?
