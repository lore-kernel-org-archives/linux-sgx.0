Received: from mga05.intel.com ([192.55.52.43]:35055 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1727144AbeH2B2G (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 28
 Aug 2018 21:28:06 -0400
Date: Tue, 28 Aug 2018 14:34:32 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Serge Ayoun
	<serge.ayoun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 07/13] x86/sgx: Add data structures for tracking the
 EPC pages
Message-ID: <20180828213432.GB29488@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
 <4666cae8-c711-8dd5-cbce-3d97cc19a9e5@intel.com>
 <20180828103040.GA21326@linux.intel.com>
 <68d730bc-898c-973f-9506-648fd8a7c610@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <68d730bc-898c-973f-9506-648fd8a7c610@intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Aug 28, 2018 at 09:53:11AM -0700, Dave Hansen wrote:
> >>> +		sgx_nr_epc_banks++;
> >>> +	}
> >>> +
> >>> +	if (!sgx_nr_epc_banks) {
> >>> +		pr_err("There are zero EPC banks.\n");
> >>> +		return -ENODEV;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>
> >> Does this support hot-addition of a bank?  If not, why not?
> ...
> > I'm not aware that we would have an ACPI specification for SGX so this
> > is all I have at the moment (does not show any ACPI event for
> > hotplugging).
> 
> So you're saying the one platform you looked at don't support hotplug.
> I was looking for a more broad statement about SGX.

Hardware doesn't support hotplug of EPC as the EPC size and location
is locked during activation of SGX.  And IIRC, activation of SGX must
be synchronized across all CPUs in a multi-socket platform, e.g. you
can't late-enable SGX on a socket and due hotplugging that way.

In a virtualized environment there are no such restrictions.  I am not
aware of any explicit requirements or use cases for supporting hotplug
of EPC, but that's probably only because virtualization of SGX is
fairly nascent.
