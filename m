Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C523C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 14:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40BFD204EC
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 14:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="bDAPGks1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403860AbfEXOop (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 10:44:45 -0400
Received: from usfb19pa13.eemsg.mail.mil ([214.24.26.84]:48250 "EHLO
        USFB19PA13.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbfEXOop (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 24 May 2019 10:44:45 -0400
X-EEMSG-check-017: 265592852|USFB19PA13_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA13.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 24 May 2019 14:44:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558709081; x=1590245081;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sMwVOvGSHbtMcc6gMG8ddOp3zQx2E03rZRQ+KqYdvUI=;
  b=bDAPGks1YSRGSGIciWnV46CFaUjfq6A6kzKM3g06yDIPF5ydgj2FUmxG
   d9SLBr+NL8u71Z60TVNdM+qMNqMYaVsEiVFqkEH1jdmkrazKnxeVvDz9o
   t3U0dnIeFsEi4Yih1pAlsS5eniCqoBmBDe5CL8RPoJ4NOqllmxY/dmBJE
   1l7puCCtVIPZ8J8bkEEWxEIRqycY4W1SB8MYwlSFLYPYsVuf/ktVY8d0E
   Yy6kIOPGP2vwh0+ZKm/TKHws0S+Cz0Rviwl6JPj/sRJwCHIhgpDweEmCX
   1NuN2Qy9IBpC93g0BcotHSStrbQel0L4G2fDNSOj/UoGu0QQGmCvQEG60
   Q==;
X-IronPort-AV: E=Sophos;i="5.60,507,1549929600"; 
   d="scan'208";a="28150197"
IronPort-PHdr: =?us-ascii?q?9a23=3AWxLUtRLGHN0YuZ1VPNmcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgUL/X4rarrMEGX3/hxlliBBdydt6sdzbOP7euwASQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagfL9+Ngi6oRjQu8UZgoZuNrs6xw?=
 =?us-ascii?q?fUrHdPZ+lY335jK0iJnxb76Mew/Zpj/DpVtvk86cNOUrj0crohQ7BAAzsoL2?=
 =?us-ascii?q?465MvwtRneVgSP/WcTUn8XkhVTHQfI6gzxU4rrvSv7sup93zSaPdHzQLspVz?=
 =?us-ascii?q?mu87tnRRn1gyocKTU37H/YhdBxjKJDoRKuuRp/w5LPYIqIMPZyZ77Rcc8GSW?=
 =?us-ascii?q?ZEWMteWTZBAoehZIURCeQPM/tTo43kq1YAqRayAA+hD/7txDBVnH/7xbA03f?=
 =?us-ascii?q?ovEQ/G3wIuEdwBv3vWo9rpO6kfSvy1wavSwDnfc/9b1zXw5Y7VeR4hu/GMWr?=
 =?us-ascii?q?dwfNLMx0kzCQzFllWQppLjPziIy+oNtnKU7+5kVe2xi28stgZ8oiOyycc3kY?=
 =?us-ascii?q?TJmoIUxUzE9SV+2oo1I8a4R1Rhbd6rF5tQqTiXOo1rSc0hW2FloDs2x7IJtJ?=
 =?us-ascii?q?KhfCUG1Y4rywDQZvCZaYSE/xTuX/uLLzhinnJqYre/ig638Uin1+LzSNG50E?=
 =?us-ascii?q?1PripZitnMsW0N1wDL5siHVPR9+kCh1C6T1w/J8OFEIF00lbHBJ549wr8/ip?=
 =?us-ascii?q?oTsUPZEi/whEr2l7OZel8h+uip7+TrerTmppmCOI9okgzyL6sjl8OlDek4Lw?=
 =?us-ascii?q?QCRXaX9Oui2LH54EH1WLBKgec3kqndvpDaP8MbpquhDg9Oz4kj8A2yDyum0d?=
 =?us-ascii?q?sEnXkHK0hJeBScj4fzIV3OL/f4Demnj1S2jDhr3+zGPqHmApjVKnjDjavhfb?=
 =?us-ascii?q?Fm5k5f1gUz19Zf6IxQCr0bJ/LzQEDxvsTCDhAlKwy03/rnCNJl24MFR22AGK?=
 =?us-ascii?q?mZPLnQsVOS+u0vI/OMZI4OuDbhLPgl//7ugmEjmV8Geqmp24AaaHG+HvR6PU?=
 =?us-ascii?q?qZZWDgjcsGEWcPpgA+VvDliEWeUT5PYHa/R6A86SshCIKlDofDQZqhgKeb0y?=
 =?us-ascii?q?e4HZ1WZ2ZGBU6KEXrzc4WEWvEMaD+dI8N7kzwEU6ShRJEl1R20qAD6zL9nJP?=
 =?us-ascii?q?LO+iIErZLjyMR15+rLmBEw8Dx0CN6d03uMT2FvhW4IQSU53KVhrkx80FuD1r?=
 =?us-ascii?q?J4g/NAH9xJ+/xJShs6NYLbz+FiEND9RBjBftiXR1u9QtWpGzUxTtYxwt8IeU?=
 =?us-ascii?q?pyB9KijhXb1SqwH7AVj6CLBIAz8q/E23jxJsB9y2vJ1aU4lFkpXNdANXC8hq?=
 =?us-ascii?q?5+6wjSB5fFk0Cel6m3aKQc2DDC+XydzWqBok5YShR8UabbUnAFYEvZs9D56l?=
 =?us-ascii?q?nFT7+0BrQtKhFBxtKaKqtWdt3pik1LRO/5N9TDZ2K8gH+wCgyVxrOIdYbqfm?=
 =?us-ascii?q?Id3CLHCEcaiQwc4XGGNQ0mDCe7v23eFCBuFU7oY0707+Z+sGm0TlU1zwGRdE?=
 =?us-ascii?q?Bhz6C6+gQUhfyHU/MT2qgLtzs/pDluG1a9xd3WAcKapwV9ZKVcfc894FBf2G?=
 =?us-ascii?q?LCqQN9Op2gL6Z/hl8RaAl3oUzu2AttColaksglsmkqzAxsJqKcyl9BcCmY3Z?=
 =?us-ascii?q?/oML3NNmby5Ayva7LR2lzG0taZ5LsP6PQiq1XkpwypGE0i829709ZP1Xuc55?=
 =?us-ascii?q?rLABAOXpL2V0Y97wJ6qK3CYikh+4PU0mVhPrWqvTDfwdIpBfcqxgyvftdeNq?=
 =?us-ascii?q?OEGxT/E8wcB8iyNuMqn0KlYQ4DPOBX7KQ0Jd+pd+Oa2K63O+ZthC+pgn5Z4I?=
 =?us-ascii?q?9jyE6M9zBzSujT35kbxfGVxQqHVzHgjFi/tsD7g5xLZTYXHmCn0yjrGJZRZr?=
 =?us-ascii?q?FufYYMEWquP8K3xtFxhpP2X35Y9VijB04a2M+zfhqSaV393AJK2UsKv3OtgT?=
 =?us-ascii?q?G4wCBskzE1sqqf2zTDw+v4dBUZNW5GX3dtjVHuIYeqi9AaWEmoYBQzmBS54k?=
 =?us-ascii?q?b6wrBRpL5jIGnLXUdIYy/2Inl+Uqu3rLqCfdRA6Jc1viVMS+m8ZVGaSrjgox?=
 =?us-ascii?q?oVyi/jEWxexC09dz63oJr5gx16iGWbLHppq3rZY85wzw/F5NPAXf5RwiYGRC?=
 =?us-ascii?q?5ghDnTB1i8OcSp/NqNm5fArO++TWShWYNXcSTw04OAuzW05XdwDR28gf+zgN?=
 =?us-ascii?q?vnHhY+0SPh0NlqTyrIpg7mYob3z6S6Lf5nfk5wCV7z6Md3G5pzkogui5EK33?=
 =?us-ascii?q?gVmJGV8WAAkWfpPtVRwbj+Y2YVRT4X397V5xDo2EliLnKP2oL4WWyRwtBuZ9?=
 =?us-ascii?q?i1eW4WxC094N5QCKuO77xLgzF1olymogLVe/R9mS0dyfQ24n4An+4JoBYtzj?=
 =?us-ascii?q?maAr0KB0ZYPjTslxGT4tC6raVXYnuvcLep2EpwmtChEbeCrRxGV3ble5ciGi?=
 =?us-ascii?q?lw4t94MFLW33358pvkd8XIbdIPqh2UlA/Nj+5VKJI2jPoKgDBoOWTmsH0/1e?=
 =?us-ascii?q?E0kBxu0oumvISdN2pt+6e5CAZCNjLpf8MT5i3tjaFGk8aQx4CvG4luFSkRU5?=
 =?us-ascii?q?vsSfKoDTcSuO/9NwmQDTI8qm2UGabFEQCD70dmqmrFE4q3OHGPOHkZ0dJiSQ?=
 =?us-ascii?q?GGJENBmgAUUys1koQjGQGqw8zhbUF56ysQ5l7+thtD1OZoOwPjXWfYoQeici?=
 =?us-ascii?q?00R4SHLBpK8gFC4F/YMdee7u1pHyBU5J6hoxaRKm2afghJDHsGWkmFB1D5Jb?=
 =?us-ascii?q?Su5N/A8/SGCeq6NffBfbKOqelGXfeS2Z2vypdm/yqLNsiXPnltFfw72lZZUn?=
 =?us-ascii?q?B+AcjZmygPRDYRlyLCdMObpRG8+jFpocC76vjkRAXv5Y6XAbtILdpv4wy2gb?=
 =?us-ascii?q?uEN+OInil5LytX1okNxX7I0rQfx14ShD9wdzaxEbQPqyjNTKHXmqJMCx4bai?=
 =?us-ascii?q?VzNNZH7q4m3wlNP9Lbhc3x1rJikvE1DFJFX0T7ms61fcwKP329NFTfCUaILr?=
 =?us-ascii?q?uGJCfHw9rpYaymSb1Qiv5Ztxy2uTaHDUDjOi6PmCXuVxCqKetMlj2UPARCuI?=
 =?us-ascii?q?GhdRZgEXPsTMr9ZxKhNN93jCM5wbs3i3/QKGETLyB2c1lRob2I8SNYnvJ/Fn?=
 =?us-ascii?q?RD7npiNumEmz2U7+vfKpYNsftrHj50l+NC4HQ+1bRV8D1ESOZymCvIod5ku0?=
 =?us-ascii?q?umnfWXyjp7TBpOrS5GhIGRskVjI6nZ9oRAVmzC/BIC9miQChIKp8d7Bd3roa?=
 =?us-ascii?q?xf1t/PlKfrIjdY793U5dccB9TTKM+fKnohMATmGDjIDAsHUzGrLnrSh0NakP?=
 =?us-ascii?q?GV+X2VqoY1poLwl5oJT78IHGAyQ9ocBlUtOMEeJ5J2RCgnkPbPiNMU4lK9oQ?=
 =?us-ascii?q?PXScEcuYrIALbaOvjmLn6yjaNFfAcP2bP1N58UMMWvwEFrbB942o/KAUvLQd?=
 =?us-ascii?q?dVoiB7dQgyiERL7HV6CGY03hS2RBmq5SooCfOsnhMwwjB7aOAp+Sakt0w7PX?=
 =?us-ascii?q?LWtSAwlw83gtyjjjePJm2iZJysVJ1bXnKn/3M6NYn2FkMsNly/?=
X-IPAS-Result: =?us-ascii?q?A2AaBwBZAuhc/wHyM5BlHAEBAQQBAQcEAQGBZYFiBSqBb?=
 =?us-ascii?q?SiEE5MLTAEBAQEBAQaBCC2JTpEFCQEBAQEBAQEBATQBAgEBhEACgj8jOBMBA?=
 =?us-ascii?q?wEBAQQBAQEBAwEBbCiCOikBgmcBBSMVQRALDgoCAiYCAlcGAQwGAgEBF4JIP?=
 =?us-ascii?q?4F3FKV5gS+FR4MqgUaBDCiLUxd4gQeBESeCaz6EJAEBgyiCWASLHRJBgWiFf?=
 =?us-ascii?q?5RwCYIPghKQegYbgWeUWoxol3shgVcrCAIYCCEPgydfkA8jAzABgQUBAYp/g?=
 =?us-ascii?q?kMBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 24 May 2019 14:44:39 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4OEiXJS009226;
        Fri, 24 May 2019 10:44:33 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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
References: <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <977d28c5-873f-fb26-63ff-18c5e06d551c@tycho.nsa.gov>
Date:   Fri, 24 May 2019 10:44:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/23/19 11:38 AM, Andy Lutomirski wrote:
> On Thu, May 23, 2019 at 7:17 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
>>> On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
>>>> But actually, there's no need to disallow mmap() after ECREATE since the
>>>> LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
>>>> mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
>>>> bypassed LSM checks?  The real problem is that mmap()'ng an existing
>>>> enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
>>>> at square one.
>>>
>>> I'm lost with the constraints we want to set.
>>
>> As is today, SELinux policies would require enclave loaders to have
>> FILE__WRITE and FILE__EXECUTE permissions on /dev/sgx/enclave.  Presumably
>> other LSMs have similar requirements.  Requiring all processes to have
>> FILE__{WRITE,EXECUTE} permissions means the permissions don't add much
>> value, e.g. they can't be used to distinguish between an enclave that is
>> being loaded from an unmodified file and an enclave that is being
>> generated on the fly, e.g. Graphene.
>>
>> Looking back at Andy's mail, he was talking about requiring FILE__EXECUTE
>> to run an enclave, so perhaps it's only FILE__WRITE that we're trying to
>> special case.
>>
> 
> I thought about this some more, and I have a new proposal that helps
> address the ELRANGE alignment issue and the permission issue at the
> cost of some extra verbosity.  Maybe you all can poke holes in it :)
> The basic idea is to make everything more explicit from a user's
> perspective.  Here's how it works:
> 
> Opening /dev/sgx/enclave gives an enclave_fd that, by design, doesn't
> give EXECUTE or WRITE.  mmap() on the enclave_fd only works if you
> pass PROT_NONE and gives the correct alignment.  The resulting VMA
> cannot be mprotected or mremapped.  It can't be mmapped at all until
> after ECREATE because the alignment isn't known before that.
> 
> Associated with the enclave are a bunch (up to 7) "enclave segment
> inodes".  These are anon_inodes that are created automagically.  An
> enclave segment is a group of pages, not necessary contiguous, with an
> upper bound on the memory permissions.  Each enclave page belongs to a
> segment.  When you do EADD, you tell the driver what segment you're
> adding to. [0]  This means that EADD gets an extra argument that is a
> permission mask for the page -- in addition to the initial SECINFO,
> you also pass to EADD something to the effect of "I promise never to
> map this with permissions greater than RX".
> 
> Then we just need some way to mmap a region from an enclave segment.
> This could be done by having a way to get an fd for an enclave segment
> or it could be done by having a new ioctl SGX_IOC_MAP_SEGMENT.  User
> code would use this operation to replace, MAP_FIXED-style, ranges from
> the big PROT_NONE mapping with the relevant pages from the enclave
> segment.  The resulting vma would only have VM_MAYWRITE if the segment
> is W, only have VM_MAYEXEC if the segment is X, and only have
> VM_MAYREAD if the segment is R.  Depending on implementation details,
> the VMAs might need to restrict mremap() to avoid mapping pages that
> aren't part of the segment in question.
> 
> It's plausible that this whole thing works without the magic segment
> inodes under the hood, but figuring that out would need a careful look
> at how all the core mm bits and LSM bits work together.
> 
> To get all the LSM stuff to work, SELinux will need some way to
> automatically assign an appropriate label to the segment inodes.  I
> assume that such a mechanism already exists and gets used for things
> like sockets, but I haven't actually confirmed this.

I don't follow that.  socket inodes are not anon inodes, and anon inodes 
have no per-instance data by definition, and typically you're only 
dealing with a single anon inode for all files, and hence they were long 
ago marked S_PRIVATE and exempted from all LSM checking except for 
EXECMEM on mmap/mprotect PROT_EXEC.  We have no way to perform useful 
security checking on them currently.  socket inodes we can label from 
their creating process but even that's not going to support multiple 
labels for different sockets created by the same process unless the 
process explicitly used setsockcreatecon(3) aka /proc/self/attr/sockcreate

> 
> [0] There needs to be some vaguely intelligent semantics if you EADD
> the *same* address more than once.  A simple solution would be to
> disallow it if the segments don't match.
> 

