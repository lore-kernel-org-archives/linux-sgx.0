Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EE3C74A5B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A5FD20863
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="RKbusrYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfGKQcK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 12:32:10 -0400
Received: from uhil19pa11.eemsg.mail.mil ([214.24.21.84]:9977 "EHLO
        uhil19pa11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGKQcJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 11 Jul 2019 12:32:09 -0400
X-EEMSG-check-017: 427376064|UHIL19PA11_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by uhil19pa11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jul 2019 16:32:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1562862727; x=1594398727;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=eDouTtMrbpx6Bx3KpeYeNi7KfGuv1TLU+XlB5gF+l6U=;
  b=RKbusrYGFyQgHPwRTX4h61YHRcM2yF5M0t8pBiWJlzer2guT/pIrWV6d
   tDWPhtf41i4uS/ov97EK8PiM0s1FDCpxNKPb7R5WBx0q+kfahV9by9Mgw
   tTX8Ie+0Zze5BXNmQD+HqqxCVTCDODDPjSdCurI8pyf0PqPIRGJfW+Ekb
   Uo8dRPPnmj8EpQwQGzE4UpHCZIgbRBnYPkyFfn876IZQDE5ucmfTprkMX
   iiQ3omjbGJ0nWfXfe4fWjgh4quPVs3Nhjy0srfd7H+Z8gILqHccddT4cC
   DsucKpXgxsasKqRpEKdN8BfxEbT/dAZ9Al/kDQeHe6lHsD24LA69zBGZ0
   w==;
X-IronPort-AV: E=Sophos;i="5.63,479,1557187200"; 
   d="scan'208";a="25613091"
IronPort-PHdr: =?us-ascii?q?9a23=3AP7NEaBfVDHW6a3Cc7Xgdf65LlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc24bBaN2/xhgRfzUJnB7Loc0qyK6vqmBTxLuM7Y+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAiooQnLucQbgoRuJrstxh?=
 =?us-ascii?q?fUv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
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
 =?us-ascii?q?qYYXvqgtcOCmoKvww+TPD0h12GSzJce3GyX6ck7DEhFI2mFZvDRpyqgLGZwC?=
 =?us-ascii?q?i0BIZWaX5GC12XCnfna4WEVO0RaCKcJs9ujCYEWaG9RIA7zx2hqAj6y79/JO?=
 =?us-ascii?q?rO5iIYrY7j1MRy5+DLkREy9Dp0D9mS0m2UVGF0kWwJSiQo3KBwv0N90E2P0a?=
 =?us-ascii?q?tmjPxCE9xc+fdJXh09NZ7GwOxwE8ryVR7ZfteVVFamRc2rATUwTtI33t8PbF?=
 =?us-ascii?q?9xG868gR/fwiqqGb4Vl6CLBZAt96Lc2GX+J9t5y3nYz6QhkVYmTdVVNWG8ha?=
 =?us-ascii?q?5w6RLTB4jXnEWdjaqqcr4c3CHV/meZ0WWOpF1YUBJ3UajdRnAQeE/WrdX/5k?=
 =?us-ascii?q?PfQL6jEqonMgRfxs6YMKdKacPmjU9ARPj9PNTSeWWxm32/BRyQ3LODcJLqe3?=
 =?us-ascii?q?kB3CXaEEUEkQUT/XGcNQgkByehuHnTDDp0GlLqfUzs8PNyqHShTk871wuKdV?=
 =?us-ascii?q?Fu16Kp+h4JgvyRU+sT0agZuCclsDh0BEyy38/SC9aZogphe6JcYckj71tdyW?=
 =?us-ascii?q?3ZsAl9bdScKPVZi1cYOy93pUL1yxJvCohais8s5CcxwQN0b6De21NbdiiE2o?=
 =?us-ascii?q?jwN6fMLW/a/RazZqqQ0VbbhoW44KAKvc8kpk3jsQfhLU8r93FqwpEByHeHzo?=
 =?us-ascii?q?nbBwoVF5TqWwA48AYs9OKSWTU0+46BjS4kCqKzqDKXnot0VeY=3D?=
X-IPAS-Result: =?us-ascii?q?A2BPAAC8Yydd/wHyM5BlGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?4FtKmpSMiiEHJJeUwaBCS1+iGCPLoFnCQEBAQEBAQEBASMRAQIBAYRAAoJTI?=
 =?us-ascii?q?zgTAQMBAQEEAQEBAQQBAWyFPAyCOikBgmYBAQEBAgEjBBFBBQsLGAICJgICV?=
 =?us-ascii?q?wYNCAEBEoJNPwGBdgUPrEV/M4VHgy2BR4EMKItfF3iBB4ERJ4I2By4+hBEBE?=
 =?us-ascii?q?gGDKYJYBJRslQJtCYIbgh+EOY0qBhuCLG2Uao5kmCghZ3ErCAIYCCEPgycJg?=
 =?us-ascii?q?kQXg06KbyMDMIEGAQGMTIJDAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 11 Jul 2019 16:32:06 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x6BGW4DG025739;
        Thu, 11 Jul 2019 12:32:05 -0400
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>
References: <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
 <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
 <4c3e21dd-8890-e3cb-0db7-c154ac7201e1@tycho.nsa.gov>
 <20190711151245.GD7645@linux.intel.com>
 <27e55a96-d5c4-69ed-a88d-7a3c26fb7f75@tycho.nsa.gov>
 <20190711162506.GF15067@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <47feea29-68c2-83ee-497a-83b616d2f90c@tycho.nsa.gov>
Date:   Thu, 11 Jul 2019 12:32:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190711162506.GF15067@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/19 12:25 PM, Sean Christopherson wrote:
> On Thu, Jul 11, 2019 at 12:11:06PM -0400, Stephen Smalley wrote:
>> On 7/11/19 11:12 AM, Sean Christopherson wrote:
>>> On Thu, Jul 11, 2019 at 09:51:19AM -0400, Stephen Smalley wrote:
>>>> I'd also feel better if there was clear consensus among all of the
>>>> @intel.com participants that this is the right approach. To date that has
>>>> seemed elusive.
>>>
>>> That's a very kind way to phrase things :-)
>>>
>>> For initial upstreaming, we've agreed that there is no need to extend the
>>> uapi, i.e. we can punt on deciding between on-the-fly tracking and having
>>> userspace specify maximal permissions until we add SGX2 support.
>>>
>>> The last open (knock on wood) for initial upstreaming is whether SELinux
>>> would prefer to have new enclave specific permissions or reuse the
>>> existing PROCESS__EXECMEM, FILE__EXECUTE and FILE__EXECMOD permissions.
>>> My understanding is that enclave specific permissions are preferred.
>>
>> I was left unclear on this topic after the email exchanges with Cedric.
>> There are at least three options:
>>
>> 1) Reuse the existing EXECMEM, EXECUTE, and EXECMOD permissions.  Pros:
>> Existing distro policies will be applied in the expected manner with respect
>> to the introduction of executable code into the system, consistent control
>> will be provided over the enclave and the host process, no change for
>> users/documentation wrt policy.  Cons: Existing permissions don't map
>> exactly to SGX semantics, no ability to distinguish executable content
>> within the enclave versus the host process at the LSM level (argued earlier
>> by Cedric to be unnecessary and perhaps meaningless), need to allow
>> FILE__EXECUTE or other checks on sigstruct files that may not actually
>> contain code.
>>
>> 2) Define new permissions within existing security classes (e.g. process2,
>> file). Pros: Can tailor permission names and definitions to SGX semantics,
>> ability to distinguish enclave versus host process execute access, no need
>> to grant FILE__EXECUTE to sigstruct files, class matches the target object,
>> permissions computed and cached upon existing checks (i.e. when a process
>> accesses a file, all of the permissions to that file are computed and then
>> cached at once, including the enclave-related ones).  Cons: Typical distro
>> policies (unlike Android) allow unknown permissions by default for forward
>> kernel compatibility reasons, so existing policies will permit these new
>> permissions by default and enforcement will only truly take effect once
>> policies are updated, adding new permissions to existing classes requires an
>> update to the base policy (so they can't be shipped as a third party policy
>> module alongside the SGX driver or installed as a local module by an admin,
>> for example), documentation/user education required for new permissions.
>>
>> 3) Define new permissions in new security classes (e.g. enclave). Pros
>> relative to #2: New classes and permissions can be defined and installed in
>> third party or local policy module without requiring a change to the base
>> policy.  Cons relative to #2: Class won't correspond to the target object,
>> permissions won't be computed and cached upon existing checks (only when
>> performing the checks against the new classes).
>>
>> Combinations are also possible, of course.
> 
> What's the impact on distros/ecosystems if we go with #1 for now and later
> decide to switch to #2 after upstreaming?  I.e. can we take a minimal-ish
> approach now without painting ourselves into a corner?

Yes, I think that's fine.

> We can map quite closely to the existing intent of EXECUTE, EXECMOD and
> EXECMEM via a combination of checking protections at enclave load time and
> again at mmap()/mprotect(), e.g.:
> 
> #ifdef CONFIG_INTEL_SGX
> static inline int enclave_has_perm(u32 sid, u32 requested)
> {
> 	return avc_has_perm(&selinux_state, sid, sid,
> 			    SECCLASS_PROCESS, requested, NULL);
> }
> 
> static int selinux_enclave_map(unsigned long prot)
> {
> 	const struct cred *cred = current_cred();
> 	u32 sid = cred_sid(cred);
> 
> 	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> 		return enclave_has_perm(sid, PROCESS__EXECMEM);
> 
> 	return 0;
> }
> 
> static int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot)
> {
> 	const struct cred *cred = current_cred();
> 	u32 sid = cred_sid(cred);
> 	int ret;
> 
> 	/* Only executable enclave pages are restricted in any way. */
> 	if (!(prot & PROT_EXEC))
> 		return 0;
> 
> 	if (!vma->vm_file || IS_PRIVATE(file_inode(vma->vm_file))) {
> 		ret = enclave_has_perm(sid, PROCESS__EXECMEM);
> 	} else {
> 		ret = file_has_perm(cred, vma->vm_file, FILE__EXECUTE);
> 		if (ret)
> 			goto out;
> 
> 		/*
> 		 * Load code from a modified private mapping or from a file
> 		 * with the ability to do W->X within the enclave.
> 		 */
> 		if (vma->anon_vma || (prot & PROT_WRITE))
> 			ret = file_has_perm(cred, vma->vm_file,
> 					    FILE__EXECMOD);
> 	}
> 
> out:
> 	return ret;
> }
> #endif
> 

