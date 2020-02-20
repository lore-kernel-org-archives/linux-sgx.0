Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA0DC11D1C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 19:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1712208CD
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 19:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgBTT5S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 14:57:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:52509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgBTT5S (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Feb 2020 14:57:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 11:57:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="254585609"
Received: from moriol-mobl.ger.corp.intel.com (HELO localhost) ([10.252.25.78])
  by orsmga002.jf.intel.com with ESMTP; 20 Feb 2020 11:57:13 -0800
Date:   Thu, 20 Feb 2020 21:57:11 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200220195537.GA23349@linux.intel.com>
References: <20191011181550.GB30935@linux.intel.com>
 <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com>
 <20191017175735.GD20903@linux.intel.com>
 <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
 <20200215072406.GA9958@linux.intel.com>
 <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
 <20200217185512.GA7677@linux.intel.com>
 <20200218104243.GA13967@wind.enjellic.com>
 <20200218155247.GA18374@linux.intel.com>
 <20200219162640.GA29921@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219162640.GA29921@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 19, 2020 at 10:26:40AM -0600, Dr. Greg wrote:
> On Tue, Feb 18, 2020 at 05:52:47PM +0200, Jarkko Sakkinen wrote:
> 
> Good morning, I hope the day is going well for everyone.
> 
> > On Tue, Feb 18, 2020 at 04:42:43AM -0600, Dr. Greg Wettstein wrote:
> > > I believe an accurate summary of Dr. Beekman's concerns are as
> > > follows:
> > > 
> > > 1.) He envisions a need for an enclave orchestrator that uses root
> > > privileges to open the SGX driver device and then drop privileges,
> > > presumably in a permanent fashion.  The orchestrator would then use
> > > the filehandle to load and initialize multiple enclaves on request.
> > > 
> > > 2.) The enclave orchestrator may be run in an environment that has
> > > SECCOMP limitations on the ability to conduct filesystem operations.
> 
> > Also UDS sockets with SCM_RIGHTS should work.
> 
> The first clarification, I'm assuming you mean passing SCM_RIGHTS over
> AF_UNIX/UNIX-domain sockets, not UDP sockets?

UNIX domain sockets.

> Secondly, it was my understanding that the reason major renovations to
> the driver were initiated, almost a year ago now, was to create a
> situation where there was a filehandle per enclave in order for the
> LSM to get a 'look' at the executable TEXT that was being deployed to
> the enclave.

File handle per enclave was driven by many things, e.g. ability to
access enclave from multiple processes either through forking or UDS
sockets.

LSM specifc changes are not part of the patch set but file handle based
model is adaptable to LSM's later on.

> It appears that the sgx_open() function, that is installed as the
> ->open method for the /dev/sgx/enclave device node, allocates the
> master enclave definition structure, that is installed, and
> subsequently released, as private data for the file instance object.
> This master enclave structure has the reference to the virtual memory
> definition for the enclave that is opened.

You can have multiple references to an enclave by using formentioned
tools.

> This would seem to imply that the driver is rather firmly architected
> on the notion of one open() per enclave, a concept that Jethro seems
> to have issues with.

I don't understand what concept you are talking about.

/Jarkko
