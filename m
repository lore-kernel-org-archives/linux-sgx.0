Return-Path: <SRS0=gNuZ=2N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD71C2D0C0
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Dec 2019 11:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A43A206D3
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Dec 2019 11:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLWLBZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 23 Dec 2019 06:01:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:32512 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfLWLBY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 23 Dec 2019 06:01:24 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 03:01:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,347,1571727600"; 
   d="scan'208";a="229296199"
Received: from amoglion-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.142])
  by orsmga002.jf.intel.com with ESMTP; 23 Dec 2019 03:01:13 -0800
Date:   Mon, 23 Dec 2019 13:01:11 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191223110111.GA4390@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <20191128182450.GA3493127@kroah.com>
 <20191206203807.GA9971@linux.intel.com>
 <20191207080939.GA193518@kroah.com>
 <20191209195719.GH19243@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209195719.GH19243@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 09, 2019 at 09:57:19PM +0200, Jarkko Sakkinen wrote:
> On Sat, Dec 07, 2019 at 09:09:39AM +0100, Greg KH wrote:
> > On Fri, Dec 06, 2019 at 10:38:07PM +0200, Jarkko Sakkinen wrote:
> > > > Why a whole cdev?
> > > > 
> > > > Why not use a misc device?  YOu only have 2 devices right?  Why not 2
> > > > misc devices then?  That saves the use of a whole major number and makes
> > > > your code a _LOT_ simpler.
> > > 
> > > The downside would be that if we ever want to add sysfs attributes, that
> > > could not be done synchronously with the device creation.
> > 
> > That is what the groups member of struct misc_device is for.
> 
> OK, cool, then there is no problem changing to misc.
> 
> I haven't seen misc drivers (not that I've looked through every single
> of them so I suppose there are such) to use it and somehow have been
> blind to seeing it that it si there.
> 
> Thanks again for the feedback. I'll fix this for the next patch set
> version.

Back in 2014 we bumped with the TPM driver to this issue with sysfs
attributes and converted the driver to have its own class to get around
the issue.

The feature came into misc in 2015 [*]. When I sent the first versions
of the patch set in 2017 I was not aware of this change (should have
checked tho). Agree that the bus was not a great choice but I just
used what I thought I had available.

[*] bd735995308b553cc3c7f6a975aa284b270c7e2c

/Jarkko
