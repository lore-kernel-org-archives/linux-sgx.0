Received: from mga09.intel.com ([134.134.136.24]:10212 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S932825AbeGCTDv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 3 Jul
 2018 15:03:51 -0400
Subject: Re: [PATCH v12 07/13] x86/sgx: data structures for tracking available
 EPC pages
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <48296e78-5979-a22f-c337-633deccf30bf@intel.com>
Date: Tue, 3 Jul 2018 12:03:48 -0700
In-Reply-To: <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On 07/03/2018 11:19 AM, Jarkko Sakkinen wrote:
> This commit adds a database of EPC banks for kernel to easily access the
> available EPC pages. On UMA architectures there is a singe bank of EPC
> pages. On NUMA architectures there is an EPC bank for each node.

Is this universally true?  What about Sub-NUMA-Clustering/Cluster-on-Die
systems?
