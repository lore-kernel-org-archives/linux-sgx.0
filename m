Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83F5C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 14:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66CCD20873
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 14:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="UKhWZxtz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfEQOCu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 10:02:50 -0400
Received: from usfb19pa11.eemsg.mail.mil ([214.24.26.82]:50243 "EHLO
        USFB19PA11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728938AbfEQOCt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 10:02:49 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 10:02:48 EDT
X-EEMSG-check-017: 141278376|USFB19PA11_EEMSG_MP7.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 13:53:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558101193; x=1589637193;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6Y9O8B/SHwMwMnoRw7FPzffWgms9Y/lzYTkz9Uhjch4=;
  b=UKhWZxtzVDo6p/hG1ulvH+yoqARFesFAPQazueWaBg5O79rg+WAzyFiz
   q2g/nDGNOfRW55xJ18lLQ38Z9x8wjojKRyTRE2MUIrmJtc2rKgSrIAKdU
   0X+ba+U2JZVejo5AL6zd2xfS7G5eHsKPsh3J/glzk3qskFP+x5AKsvRuR
   nJHAKbEdnpTp5/zeq7SkEThwfrcLwUdualYmvGcxPZH8LcaSJ86LioNq/
   3D5F92VaOfL9r873UG83xM0o92bHqemmVSk/dagE2zfELGrudLvMiJ6g6
   PBaTR/HHdxRAYJNIWxDwaVXXgomO5pfmuLRN0g91TKjEjOw3Q92TpM6IP
   g==;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="27854010"
IronPort-PHdr: =?us-ascii?q?9a23=3AwUk5GBeP4Y6s1Apm0/jKyAEClGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc6/YxyN2/xhgRfzUJnB7Loc0qyK6vmmADRaqsjR+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAiroQnLq8UanZVuJqkwxx?=
 =?us-ascii?q?bKv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/XrJgcJskq1UvBOhpwR+w4HKZoGVKOF+db7Zcd8DWG?=
 =?us-ascii?q?ZNQtpdWylHD4yydYsPC/cKM/heoYfzulACqQKyCAmoCe/qzDJDm3340rAg0+?=
 =?us-ascii?q?k5DA/IwgIgEdINvnraotr6O6UdXvy6wqTT0TXObOlb1Svh5IXGcB0sp+yHU7?=
 =?us-ascii?q?JqccrWzEkiDx7LjkmOpoz9PzOayOINuHWG4eplT+2vj2onpB9xozOywcoskZ?=
 =?us-ascii?q?TGhpkOx1DY9SR23IY1JdqiRE59et6rCoFcty6dN4toW84vRXxjtiUiyrAepJ?=
 =?us-ascii?q?K2cycHxI4nyhLCcfCLbYeF7gz5WOqMJzpzmWhrd6ilhxmo9Eit0uj8Vs6p31?=
 =?us-ascii?q?lUtidFidzMtmwV1xzU98iHVuNx/ke/1jaL0ADe8v1ELloularaNp4h2aQ8lo?=
 =?us-ascii?q?YTsEvfHi/2n1/6jKmKeUU/5uek8eHnYrTippOENo90jB/xMrg2l8CiDuk1PR?=
 =?us-ascii?q?ICUmiG9eimyrHu8lP1TK9XgvEul6nWqpHaJcAVpq6jBA9V154u6w2iADe9y9?=
 =?us-ascii?q?kYgXkGI05FeBKAlYTpPUrOL+riAfewhFSsji9nx+raMb35HpXNMn/Dna/9cr?=
 =?us-ascii?q?lj9kFc0gszwsxF65NbC7EBJv3zV1TwtNzeEh82LQi0z/z7B9V604MUQXiPDb?=
 =?us-ascii?q?OBMKPOrV+I4foiI+2RZI8JvzbwMPsl6OD0jX8/h1AdebOl3ZwNaHC3Bv5mOV?=
 =?us-ascii?q?mWYWLwgtcdFmcHpgg+TOntiF2YSz5TZm2yUrk65j4hDYKpE4bDSpqqgLyb0y?=
 =?us-ascii?q?exBodWaXxeClCQDXfocJ2JW+wSZy2IJM9tiD4EWaK9RI8hzxGutRT6y6ZgLu?=
 =?us-ascii?q?rM+i0Xq4jj1MNy5+3Vjhwy9Dp0D9iD3GGJVW17gmQIRzou1qBlvUN90kuD0b?=
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
 =?us-ascii?q?yS+XqVrp81qpjohpUCUKNUVFswFqBSNkMwVuwDJpgzFhgpnaSah4RAsXGzoA?=
 =?us-ascii?q?PQT4NKv5bIfvOUHfjrbj2eiO8ALzIOzaKwCZkPMYj6wVdhaxEumJnWHGLTUM?=
 =?us-ascii?q?pLryknaRU79hZj6n97G1Yv1lrlZwXl23oaEfq5j1ZikQdlSfg8/zfrpVEsLx?=
 =?us-ascii?q?zFozVmwxp5osnsnT3EKG25F6y3R4wDTnOp5kU=3D?=
X-IPAS-Result: =?us-ascii?q?A2CaAwCxu95c/wHyM5BeBhwBAQEEAQEHBAEBgWWBZyqBO?=
 =?us-ascii?q?gEyhDqTCE0BAQEBAQaBCC2JTpECCQEBAQEBAQEBATQBAgEBhEACgjQjOBMBA?=
 =?us-ascii?q?wEBAQQBAQEBAwEBbCiCOikBgmYBAQEBAgEjDwEFQRALGAICJgICVwYBDAgBA?=
 =?us-ascii?q?YJfP4F3BQ+qGoEvhUeDKYFGgQwoi1EXeIEHgREngms+g34fGYMYglgEjUSZb?=
 =?us-ascii?q?WUJgg2CD5BmBhuCHYpOiS2MUZdFIYFXKwgCGAghD4MoghoXjjsjA4E2AQGMK?=
 =?us-ascii?q?A8XgiwBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 17 May 2019 13:53:11 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HDr6hq018938;
        Fri, 17 May 2019 09:53:07 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     James Morris <jmorris@namei.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
Date:   Fri, 17 May 2019 09:53:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/16/19 6:23 PM, Xing, Cedric wrote:
> Hi Andy,
> 
>>> SIGSTRUCT isn't necessarily stored on disk so may not always have a fd.
>> How about the following?
>>> void *ss_pointer = mmap(sigstruct_fd, PROT_READ,...);
>>> ioctl(enclave_fd, SGX_INIT_THE_ENCLAVE, ss_pointer);
>>>
>>> The idea here is SIGSTRUCT will still be passed in memory so it works
>> the same way when no LSM modules are loaded or basing its decision on
>> the .sigstruct file. Otherwise, an LSM module can figure out the backing
>> file (and offset within that file) by looking into the VMA covering
>> ss_pointer.
>>
>> I don’t love this approach.  Application authors seem likely to use
>> read() instead of mmap(), and it’ll still work in many cares. It would
>> also complicate the kernel implementation, and looking at the inode
>> backing the vma that backs a pointer is at least rather unusual.
>> Instead, if the sigstruct isn’t on disk because it’s dynamic or came
>> from a network, the application can put it in a memfd.
> 
> I understand your concern here. But I guess we are making too much assumption on how enclaves are structured/packaged. My concern is, what if a SIGSTRUCT really has to be from memory? For example, an enclave (along with its SIGSTRUCT) could be embedded inside a shared object (or even the "main" executable) so it shows up in memory to begin with. Of course it could be copied to a memfd but whatever "attributes" (e.g. path, or SELinux class/type) associated with the original file would be lost, so I'm not sure if that would work.
> 
> I'm also with you that applications tend to use read() instead of mmap() for accessing files. But in our case that'd be necessary only if .sigstruct is a separate file (hence needs to be read separately). What if (and I guess most implementations would) the SIGSTRUCT is embedded in the same file as the enclave? mmap() is the more common practice when dealing with executable images, and in that case SIGSTRUCT will have already been mmap()'d.
> 
> I'm with you again that it's kind of unprecedented to look at the backing inode. But I believe we should strive to allow as large variety of applications/usages as possible and I don't see any alternatives without losing flexibility.
> 
>>>
>>>>
>>>> /* Actually map the thing */
>>>> mmap(enclave_fd RO section, PROT_READ, ...);
>>>> mmap(enclave_fd RW section, PROT_READ | PROT_WRITE, ...);
>>>> mmap(enclave_fd RX section, PROT_READ | PROT_EXEC, ...);
>>>>
>>>> /* This should fail unless EXECMOD is available, I think */
>>>> mmap(enclave_fd RWX section, PROT_READ | PROT_WRITE | PROT_EXEC);
>>>>
>>>> And the idea here is that, if the .enclave file isn't mapped
>>>> PROT_EXEC, then mmapping the RX section will also require EXECMEM or
>>>> EXECMOD.
>>>
>>>  From security perspective, I think it reasonable to give EXECMEM and
>> EXECMOD to /dev/sgx/enclave because the actual permissions are guarded
>> by EPCM permissions, which are "inherited" from the source pages, whose
>> permissions have passed LSM checks.
>>
>> I disagree.  If you deny a program EXECMOD, it’s not because you
>> distrust the program. It’s because you want to enforce good security
>> practices.  (Or you’re Apple and want to disallow third-party JITs.)
>> A policy that accepts any sigstruct but requires that enclaves come
>> from disk and respect W^X seems entirely reasonable.
>>
>> I think that blocking EXECMOD has likely served two very real security
>> purposes. It helps force application and library developers to write
>> and compile their code in a way that doesn’t rely on dangerous tricks
>> like putting executable trampolines on the stack.  It also makes it
>> essentially impossible for an exploit to run actual downloaded machine
>> code — if there is no way to run code that isn’t appropriately
>> labeled, then attackers are more limited in what they can do.
> 
>>
>> I don’t think that SGX should become an exception to either of these.
>> Code should not have an excuse to use WX memory just because it’s in
>> an enclave. Similarly, an exploit should not be able to run an
>> attacker-supplied enclave as a way around a policy that would
>> otherwise prevent downloaded code from running.
> 
> My apology for the confusion here.
> 
> I thought EXECMOD applied to files (and memory mappings backed by them) but I was probably wrong. It sounds like EXECMOD applies to the whole process so would allow all pages within a process's address space to be modified then executed, regardless the backing files. Am I correct this time?

No, you were correct the first time I think; EXECMOD is used to control 
whether a process can make executable a private file mapping that has 
previously been modified (e.g. text relocation); it is a special case to 
support text relocations without having to allow full EXECMEM (i.e. 
execute arbitrary memory).

SELinux checks relevant to W^X include:

- EXECMEM: mmap/mprotect PROT_EXEC an anonymous mapping (regardless of 
PROT_WRITE, since we know the content has to have been written at some 
point) or a private file mapping that is also PROT_WRITE.
- EXECMOD: mprotect PROT_EXEC a private file mapping that has been 
previously modified, typically for text relocations,
- FILE__WRITE: mmap/mprotect PROT_WRITE a shared file mapping,
- FILE__EXECUTE: mmap/mprotect PROT_EXEC a file mapping.

(ignoring EXECSTACK and EXECHEAP here since they aren't really relevant 
to this discussion)

So if you want to ensure W^X, then you wouldn't allow EXECMEM for the 
process, EXECMOD by the process to any file, and the combination of both 
FILE__WRITE and FILE__EXECUTE by the process to any file.

If the /dev/sgx/enclave mappings are MAP_SHARED and you aren't using an 
anonymous inode, then I would expect that only the FILE__WRITE and 
FILE__EXECUTE checks are relevant.

> 
> I was not saying enclaves were exempt to good security practices. What I was trying to say was, EPC pages are *not* subject to the same attacks as regular pages so I suspect there will be a desire to enforce different policies on them, especially after new SGX2 features/applications become available. So I think it beneficial to distinguish between regular vs. enclave virtual ranges. And to do that, a new VM_SGX flag in VMA is probably a very simple/easy way. And with that VM_SGX flag, we could add a new security_sgx_mprot() hook so that LSM modules/policies could act differently.
> 
> And if you are with me on that bigger picture, the next question is: what should be the default behavior of security_sgx_mprot() for existing/non-SGX-aware LSM modules/policies? I'd say a reasonable default is to allow R, RW and RX, but not anything else. It'd suffice to get rid of EXECMEM/EXECMOD requirements on enclave applications. For SGX1, EPCM permissions are immutable so it really doesn't matter what security_sgx_mprot() does. For SGX2 and beyond, there's still time and new SGX-aware LSM modules/policies will probably have emerged by then.
> 
> -Cedric
> 

