Return-Path: <SRS0=+BDs=4F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48B2C34022
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Feb 2020 18:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA05720836
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Feb 2020 18:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgBQSzc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Feb 2020 13:55:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:59820 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgBQSzc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Feb 2020 13:55:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Feb 2020 10:55:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,453,1574150400"; 
   d="scan'208";a="228506609"
Received: from aottaski-mobl.ger.corp.intel.com (HELO localhost) ([10.251.85.113])
  by orsmga008.jf.intel.com with ESMTP; 17 Feb 2020 10:55:28 -0800
Date:   Mon, 17 Feb 2020 20:55:26 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200217185512.GA7677@linux.intel.com>
References: <20191010113745.GA12842@linux.intel.com>
 <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
 <20191011181550.GB30935@linux.intel.com>
 <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com>
 <20191017175735.GD20903@linux.intel.com>
 <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
 <20200215072406.GA9958@linux.intel.com>
 <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 17, 2020 at 09:52:25AM +0100, Jethro Beekman wrote:
> On 2020-02-15 08:24, Jarkko Sakkinen wrote:
> > On Thu, Feb 13, 2020 at 03:10:24PM +0100, Jethro Beekman wrote:
> >>>> There are other scenarios where it's not just the permissions on
> >>>> /dev/sgx/enclave that are the problem but using the filesystem in general
> >>>> that is. Maybe you've used seccomp to disable file operations, etc.
> >>>
> >>> Andy and Jarkko, thoughts?
> >>
> >> Folks, any more thoughts on how to resolve the issue that you need to
> >> call open() for every enclave?
> > 
> > Why is it an issue?
> 
> Already discussed in https://www.spinics.net/lists/linux-sgx/msg02075.html

Not anyone has to have access to open /dev/sgx/enclave in order to use
enclaves.

It is as much a problem as for practically any driver that provides
devices for some use.

/Jarkko
