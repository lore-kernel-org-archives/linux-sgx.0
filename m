Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D56C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 16:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D458120848
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 16:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="nyfXO3s9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfEQQ1r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 12:27:47 -0400
Received: from ucol19pa12.eemsg.mail.mil ([214.24.24.85]:57962 "EHLO
        UCOL19PA12.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQQ1r (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 12:27:47 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 12:27:46 EDT
X-EEMSG-check-017: 19847535|UCOL19PA12_EEMSG_MP10.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="19847535"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UCOL19PA12.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 16:20:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558110023; x=1589646023;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UDyBl3LG9e2Y5cYiOus/cMxJVgxWaQYXKA8D/9NMKS8=;
  b=nyfXO3s9Otnj/niEc+l+0M8HBL5k72ErRHhKSpyCrKQ2E+zx46X5Ieib
   ZWClPqVfEOv0zrTRLD+PwV2QjS8xu1VTSanEJV/mbaDQa59wcOWVYSjue
   JBVN7U6E83vmBzy+UnpHJOrON93645qXgHRindHDbXatNjWl/Y0BsZNfc
   7HczcoD90EJBj1b3Ov+T4FJBIgK/QkFKqO47umZldj9E0LyLYxgbNk3yo
   sY98i//uudvimyRVDT39lxLlhzPue7ug4MzMQN3YE7Zo2V7jp5uBQRhiP
   CCWkPpT+T5iOE22PQpfFHbtKY++dbVZ0+IpeJgj7XvMpbHNg6agGmweLa
   g==;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="27866951"
IronPort-PHdr: =?us-ascii?q?9a23=3AT9/TxxdJrwZkiMxRx7wPRtG4lGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc6/YRyN2/xhgRfzUJnB7Loc0qyK6vmmADRaqsfQ+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAiroQnLq8UanZVuJqk1xx?=
 =?us-ascii?q?bNv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/XrJgcJskq1UvBOhpwR+w4HKZoGVKOF+db7Zcd8DWG?=
 =?us-ascii?q?ZNQtpdWylHD4yydYsPC/cKM/heoYfzulACqQKyCAmoCe/qzDJDm3340rAg0+?=
 =?us-ascii?q?k5DA/IwgIgEdINvnraotr6O6UdXvy6wqTT0TXObelb1Svh5IXGcB0sp+yHU7?=
 =?us-ascii?q?JqccrWzEkiDx7LjkmOpoz9PzOayOINuHWG4eplT+2vj2onpB9xozOywcoskZ?=
 =?us-ascii?q?TGhpkOx1DY9SR23IY1JdqiRE59et6rCoFcty6dN4toW84vRXxjtiUiyrAepJ?=
 =?us-ascii?q?K2cycHxI4nyhLCcfCLbYeF7gz5WOqMJzpzmWhrd6ilhxmo9Eit0uj8Vs6p31?=
 =?us-ascii?q?lUtidFidzMtmwV1xzU98iHVuNx/ke/1jaL0ADe8v1ELloularaNp4h2aQ8lo?=
 =?us-ascii?q?YTsEvfHi/2n1/6jKmKeUU/5uek8eHnYrTippOENo90jB/xMrg2l8CiDuk1PR?=
 =?us-ascii?q?ICUmiG9eimyrHu8lP1TK9XgvEul6nWqpHaJcAVpq6jBA9V154u6w2iADe9y9?=
 =?us-ascii?q?kYgXkGI05FeBKAlYTpPUrOL+riAfewhFSsji9nx+raMb35HpXNMn/Dna/6fb?=
 =?us-ascii?q?lj8UFczhA/zdJF651ICrEBOvPzWlTttNzfFh85MxK7w/z8CNV60IMTQmOPAq?=
 =?us-ascii?q?mFMKzMtV+E/P4gI+6JZIUNojbyN+Al5+LyjX8+gVISYbem0oYNaHC5AvtqOU?=
 =?us-ascii?q?qYYXvqgtcOCmoKvww+TPD0h12GSzJce3GyX6ck7DEhFI2mFZvDRpyqgLGZ2C?=
 =?us-ascii?q?e7A4FWZmddB1CPD3jobYOEVOkIaC6IJc9hiDMEX6C7S4A9zRGuqBP6y71/I+?=
 =?us-ascii?q?rW/y0Ysojj1MJ05+3Ijhwy8yZ7D8GD3GGMVW10mXkIRzAu1qBlvUN90kuD0b?=
 =?us-ascii?q?R/g/FADtxc+elJUggkOpPHz+x1EdTyWgbBf9ePUlqpXtKmATQpRNIr39AOe1?=
 =?us-ascii?q?p9G8mljh3b2yqqArkVl6GEBZAt6aLTwWT+J9tny3bHyKkgj0AqQs5INWK7m6?=
 =?us-ascii?q?5/8xbcCpXXk0WWiamqb74Q3C3T+2eZy2qBokVYXBR3UaXfUnAVflHWosjh5k?=
 =?us-ascii?q?PeU7+uDqwqMhNbxs6fLqtHccXpgk9bRPfnIdjeZmWxm2CqBRmW3L+DcI3qe2?=
 =?us-ascii?q?AF1iXHFEcEixwT/WqBNQUmGCihu3jRDCZvFVL0eE7s6fNxqGm6Tk8v1wGKa1?=
 =?us-ascii?q?du2Kar9RIPgvycUfwT1KoeuCg9szV0AEq939XOBtqbuQVheKRcYdUg4FZIzm?=
 =?us-ascii?q?/ZqQN9MYK6L6x4hV4RbR53v0Xw2BVzEIlAltIqrHwyxgpoNa2YyE9Bdy+f3Z?=
 =?us-ascii?q?3oOL3YMHPy/BOsa67RwF3ey8yZ+qQM6PQ5rVXsogepG1Em83Vm1dlVznSd6o?=
 =?us-ascii?q?/LDAoUTZL+TEI3+wJmqLHdZyk3/5nU2mF0Mamorj/C3MokBOk7xRa8f9dfKq?=
 =?us-ascii?q?SEGRT8E80dHciuNPYlm16obhMLJuxd6Kk0P8a+ffucxKGrJPpgnC6hjWlf/Y?=
 =?us-ascii?q?9yyFyM+DRmRu7IxZkFxeqY0RWBVzrnjVehtNz3lp5AZT0IAmW/zi3kDpZLZq?=
 =?us-ascii?q?JuZYYLFXuuI8qvy9ViiJ7tX3FZ+UWnB1MH3s+pZAaSb0b63Q1W1EQWrmarlj?=
 =?us-ascii?q?amwDZsiTEmsrKf3DDSw+TlbBcHNXRLS3dtjVr3P4e0idIaU1asbwgtlRuq+V?=
 =?us-ascii?q?z2yLRcpKR6N2PTW1tHfzDqL2F+Vau9rqaCY8lV6JM2qypXVPmzYUuBR775oh?=
 =?us-ascii?q?sa1T7jHmRHyDA1cDGqp5P5kAFgh2KBLXZzq3zZddt3xRfF69zWXeRR0SYeRC?=
 =?us-ascii?q?lklTnXAUCxP92o/dWSipfCvfmyV2G/WZ1Jdynk04eAuTCl5W1lHxK/heq/mt?=
 =?us-ascii?q?75Hggg1y/0yd1qWT/PrBbmbYnhz766Pv5/fkl0GF/87NJ3G459n4Yxn5wQ2m?=
 =?us-ascii?q?YVho+T/XUZlWf/K9Jb2bjxbHAVXz4E38bV4BT52E1kNn+Jw4P5VnOAwspuft?=
 =?us-ascii?q?W6eWwW2y0m4sBUB6eb8qZEkTF2olWmtwLRZ+ZynjMHxfsp8n4ajPkDuBAxwS?=
 =?us-ascii?q?WFHrASAU5YMDT2mBSL99C+qb5aZGKucbi2yUp/ksmtDL+FogFBXnb2Z40tHT?=
 =?us-ascii?q?Nx7sV4NlLAynrz6pvreNPId9IcqgWUkwvcj+hSMJ8xkPoKhS19OWL4p3Ilzf?=
 =?us-ascii?q?U2jQZw0p6nvIiIMXlt8LilDR5fMz3/f9kT9S31jaZCgsaW2JiiHpN5GjUOQJ?=
 =?us-ascii?q?TnUeinEDYWtfT6MgaDCyc8pWmGFrrfBwCf9F1qoG7IE5CuL3uXPmUWzc1+RB?=
 =?us-ascii?q?mBI0xSmBsUUysgnp42CA+m3tbucUd+5jAM4F71sRpMyuR0NxbhVmfTvhunaj?=
 =?us-ascii?q?AxSJKHNhpZ8hlC51vJMcyZ9u9zBCFY8YehrQCXKWyUfRhIDGAQVk2FHV/jO7?=
 =?us-ascii?q?iu5cPb/uiZAOq+M+XBYbGUpeNCUPeIwIql0pF68DaUKsWPIn5iAuU72kVZXH?=
 =?us-ascii?q?B5B97WmzIVRywXiiLCdcibpBin9y12qMC/7OrkWAb16YSTDLtSNM1l+wqqjq?=
 =?us-ascii?q?ebK+6QmCF5JC5C2ZMK2HDI0rkf3V4IhyF1dzmiD6oAujLNTK3OnK9XDBkbZj?=
 =?us-ascii?q?h3NMtJ6aI8wwZMNdTaitPzyr53kPo1B01ZWlzmn8GjfdYKLH2lNFPbGEaLM6?=
 =?us-ascii?q?yLJT7RzMH2e6+8UqNQg/9Utx22ojubEknjPiidmDntTRygLeZMjCSDNhxEpI?=
 =?us-ascii?q?69agptCXTkTN/+cRK7KMR6gicywb01mHzKM20RPSJhfExTtreQ9z9Xgu1jG2?=
 =?us-ascii?q?xd6XpoNeuEmyGC7+nYMZsWs/xrAj90l+JG+nQ6yqNV7CVaS/xphCvetNluo0?=
 =?us-ascii?q?upkuOX0DpoTAJOqipXhIKMpUhiOr/W9phaVXbE4RIC92OQCxsRqttkDN3vp7?=
 =?us-ascii?q?5fytzVmK3vLzdC9sre/dEACMjMNMKHLH0hPALzGD7VEgQFSyKrNWPBiExGi/?=
 =?us-ascii?q?yS+XqVrp81qpjohpUCUKNUVFswFqBSNkMwJ9ELJt9cXikliqKclM4F/2G5ql?=
 =?us-ascii?q?GFX8hTuNbFEPmSG/T0NDGBjbRefBwO6bL+MYkXcIb83hoxREN9mdHxB0fIXd?=
 =?us-ascii?q?1L6hZkZwswrVQFpGNyVUUvyknlbUWr+3ZVGvmqyE1lwjBiaPggoW+/q2w8IU?=
 =?us-ascii?q?DH8W5pzRg8?=
X-IPAS-Result: =?us-ascii?q?A2AwAQCp3t5c/wHyM5BkGwEBAQEDAQEBBwMBAQGBZYFiB?=
 =?us-ascii?q?SqBOgEyhDqTCk0BAQEBAQaBCC2JTpECCQEBAQEBAQEBATQBAgEBhEACgjQjO?=
 =?us-ascii?q?BMBAwEBAQQBAQEBAwEBbCiCOikBgmcBBSMVQRALGAICJgICVwYNCAEBgl8/g?=
 =?us-ascii?q?XcUqliBL4VIgyaBRoEMKItRF3iBB4E4gms+h06CWASNRIV8lFYJgg2CD5BmB?=
 =?us-ascii?q?huWGKQWIYFXKwgCGAghD4MokGwjA4E2AQGOegEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 17 May 2019 16:20:22 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HGKJbw004156;
        Fri, 17 May 2019 12:20:19 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
References: <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
Date:   Fri, 17 May 2019 12:20:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517150948.GA15632@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 11:09 AM, Sean Christopherson wrote:
> On Fri, May 17, 2019 at 09:53:06AM -0400, Stephen Smalley wrote:
>> On 5/16/19 6:23 PM, Xing, Cedric wrote:
>>> I thought EXECMOD applied to files (and memory mappings backed by them) but
>>> I was probably wrong. It sounds like EXECMOD applies to the whole process so
>>> would allow all pages within a process's address space to be modified then
>>> executed, regardless the backing files. Am I correct this time?
>>
>> No, you were correct the first time I think; EXECMOD is used to control
>> whether a process can make executable a private file mapping that has
>> previously been modified (e.g. text relocation); it is a special case to
>> support text relocations without having to allow full EXECMEM (i.e. execute
>> arbitrary memory).
>>
>> SELinux checks relevant to W^X include:
>>
>> - EXECMEM: mmap/mprotect PROT_EXEC an anonymous mapping (regardless of
>> PROT_WRITE, since we know the content has to have been written at some
>> point) or a private file mapping that is also PROT_WRITE.
>> - EXECMOD: mprotect PROT_EXEC a private file mapping that has been
>> previously modified, typically for text relocations,
>> - FILE__WRITE: mmap/mprotect PROT_WRITE a shared file mapping,
>> - FILE__EXECUTE: mmap/mprotect PROT_EXEC a file mapping.
>>
>> (ignoring EXECSTACK and EXECHEAP here since they aren't really relevant to
>> this discussion)
>>
>> So if you want to ensure W^X, then you wouldn't allow EXECMEM for the
>> process, EXECMOD by the process to any file, and the combination of both
>> FILE__WRITE and FILE__EXECUTE by the process to any file.
>>
>> If the /dev/sgx/enclave mappings are MAP_SHARED and you aren't using an
>> anonymous inode, then I would expect that only the FILE__WRITE and
>> FILE__EXECUTE checks are relevant.
> 
> Yep, I was just typing this up in a different thread:
> 
> I think we may want to change the SGX API to alloc an anon inode for each
> enclave instead of hanging every enclave off of the /dev/sgx/enclave inode.
> Because /dev/sgx/enclave is NOT private, SELinux's file_map_prot_check()
> will only require FILE__WRITE and FILE__EXECUTE to mprotect() enclave VMAs
> to RWX.  Backing each enclave with an anon inode will make SELinux treat
> EPC memory like anonymous mappings, which is what we want (I think), e.g.
> making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
> 64-bit only at this point, so SELinux will always have default_noexec).

I don't think we want to require EXECMEM (or equivalently both 
FILE__WRITE and FILE__EXECUTE to /dev/sgx/enclave) for making any EPC 
page executable, only if the page is also writable or previously 
modified.  The intent is to prevent arbitrary code execution without 
EXECMEM (or FILE__WRITE|FILE__EXECUTE), while still allowing enclaves to 
be created without EXECMEM as long as the EPC page mapping is only ever 
mapped RX and its initial contents came from an unmodified file mapping 
that was PROT_EXEC (and hence already checked via FILE__EXECUTE).
